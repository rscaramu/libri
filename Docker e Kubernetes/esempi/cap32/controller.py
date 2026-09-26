"""Controller minimo per la risorsa Backup."""
from kubernetes import client, config, watch

GRUPPO, VERSIONE, PLURALE = "dati.example.com", "v1", "backup"


def crea_job(api, ns, nome, spec):
    corpo = {
        "apiVersion": "batch/v1",
        "kind": "Job",
        "metadata": {"name": f"backup-{nome}",
                     "namespace": ns},
        "spec": {"template": {"spec": {
            "restartPolicy": "Never",
            "containers": [{
                "name": "backup",
                "image": "ghcr.io/rscaramu/backup-tool:1.0",
                "args": [spec["sorgente"],
                         spec["destinazione"]]}]}}},
    }
    api.create_namespaced_job(ns, corpo)


def riconcilia(custom, batch, evento):
    obj = evento["object"]
    ns = obj["metadata"]["namespace"]
    nome = obj["metadata"]["name"]
    fase = obj.get("status", {}).get("fase")
    if evento["type"] == "DELETED" or fase == "Completato":
        return
    if fase is None:
        crea_job(batch, ns, nome, obj["spec"])
        custom.patch_namespaced_custom_object_status(
            GRUPPO, VERSIONE, ns, PLURALE, nome,
            {"status": {"fase": "InCorso"}})


def main():
    config.load_incluster_config()
    custom = client.CustomObjectsApi()
    batch = client.BatchV1Api()
    for evento in watch.Watch().stream(
            custom.list_cluster_custom_object,
            GRUPPO, VERSIONE, PLURALE):
        riconcilia(custom, batch, evento)


if __name__ == "__main__":
    main()
