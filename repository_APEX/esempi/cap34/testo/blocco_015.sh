$ sf project deploy validate \
    --source-dir force-app/main/default/classes \
    --target-org collaudo \
    --test-level RunSpecifiedTests \
    --tests RiepilogoTest --tests FatturazioneTest \
    --wait 30
$ sf project deploy quick --use-most-recent \
    --target-org collaudo
