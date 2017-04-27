# Creating a Let's Encrypt Certificate with Apache on Ubuntu

**Instructions**
* Shutdown apache:  
  `sudo systemctl stop apache2`
* Run lets encrypt for the domain:  
  `sudo letsencrypt certonly -d example.org -d www.example.org --email dev@example.org --agree-tos`
* Update your virtual host to point to the newly created certificates.
* Start apache:  
  `sudo systemctl start apache2`