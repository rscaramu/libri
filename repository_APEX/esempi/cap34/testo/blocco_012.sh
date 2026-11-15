$ sf project generate --name manuale-apex
$ cd manuale-apex
$ sf org login web --alias dev --set-default
$ sf project retrieve start --metadata ApexClass \
    --metadata ApexTrigger
$ ls force-app/main/default/classes/*.cls | wc -l
$ ls force-app/main/default/triggers/*.trigger | wc -l
