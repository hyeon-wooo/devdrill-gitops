kubectl taint node home52 dedicated=devdrill:NoSchedule --overwrite
kubectl label node home52 dedicated=devdrill --overwrite
