$ sf org create scratch \
    --definition-file config/project-scratch-def.json \
    --alias prova --duration-days 7 --set-default
$ sf project deploy start
$ sf apex run test --test-level RunLocalTests --wait 20
$ sf org delete scratch --target-org prova --no-prompt
