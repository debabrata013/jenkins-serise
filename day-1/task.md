Today I worked on setting up a secure DevOps environment on the VPS.

First I created a separate dev user and configured SSH key based login.
I kept the public SSH key inside /home/dev/.ssh/authorized_keys and gave
the user sudo access.

Then I configured Docker access for the dev user. Initially docker ps
was giving permission denied, while sudo docker ps was working. I added
dev to the docker group and refreshed the session using newgrp docker,
after which Docker worked without sudo.

After that I set up Jenkins using Docker Compose. I created a simple
Jenkins-Demo freestyle project and tested a basic Execute Shell build.

I also configured Nginx for jenkins.glausco.tech and used it as a
reverse proxy to Jenkins. During the setup I faced a symlink issue where
Nginx showed “Too many levels of symbolic links”. The problem was caused
by creating the sites-enabled symlink with the wrong path. I removed it
and created the correct absolute-path symlink.

Another issue was an Nginx configuration error caused by an extra
closing bracket and an incorrect proxy_pass format. I corrected the
configuration and verified it using nginx -t.

Certbot initially gave a permission denied error because it was run
without sudo. I fixed this by running certbot with sudo and configured
HTTPS for the Jenkins domain.

Finally, Jenkins was showing UTC time instead of Indian time. I fixed
this by setting TZ=Asia/Kolkata in the Jenkins Docker Compose
configuration and recreated the container.

Overall, today I practiced Linux user management, SSH security, Docker
permissions, Docker Compose, Jenkins, Nginx reverse proxy, SSL with
Certbot, and basic troubleshooting on a VPS.