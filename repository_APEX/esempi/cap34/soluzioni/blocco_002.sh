$ sf org create scratch \
    --definition-file config/project-scratch-def.json \
    --alias breve --duration-days 3 --set-default
$ sf project deploy start
$ sf apex run --file script/dati.apex
$ sf apex run test --test-level RunLocalTests \
    --code-coverage --wait 20
$ sf org delete scratch --target-org breve --no-prompt
