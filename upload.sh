rm -rf /tmp/kube.zip

zip /tmp/kube.zip -r *

scp /tmp/kube.zip root@172.16.3.235:/opt
scp /tmp/kube.zip wangoo@40.125.170.232:/home/wangoo

