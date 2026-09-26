# Manuale completo di Docker e Kubernetes — materiale per i lettori

Materiale di accompagnamento al volume *Manuale completo di Docker e Kubernetes. Dai fondamenti dei container all’orchestrazione in produzione* di Roberto Scaramuzzino.

- `esempi/capNN/` — Dockerfile, file Compose, manifest Kubernetes, chart Helm e kustomization di ogni capitolo, nella forma in cui compaiono nel libro, validati con hadolint, `docker compose config`, kubeconform (schemi Kubernetes 1.31), `helm lint` e `kubectl kustomize`.
- `PROMPT_IA.md` — i 102 prompt dei paragrafi «Con l’IA», per capitolo.
- `ERRATA.md` — correzioni al testo, aggiornato dopo la pubblicazione.

Versioni di riferimento: Docker Engine 27, Compose v2, Kubernetes 1.31, kind 0.24, Helm 3.16.
