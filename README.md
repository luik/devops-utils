# AMI locator

http://cloud-images.ubuntu.com/locator/ec2/

# devops-utils

You can use for example a script with the command

    curl -sL https://raw.githubusercontent.com/luik/devops-utils/master/linux-scripts/create-nvme-fs.sh | sudo -E bash -
    
## Notes installing on another cloud provider

You should create folder `/media/nvme1/data` IE installing a jira:

    sudo mkdir -p /media/nvme1/data/
    sudo chown ubuntu:ubuntu /media/nvme1/data/

    git clone https://github.com/luik/devops-utils

    cd devops-utils/linux-scripts/

    sudo apt update

    ./install-mysql-server.sh
    # copy root password

    ./install-apache.sh
    ./install-java.sh



    ./install-a-jira-instance.sh
    j71
    8080
    jira7-1.dev.milkneko.milkneko.com
    VkjFruG1b4i6MNuY

    jira_j71
    jira_j71_admin
    PCTmC4CtIgf5GJHm

## Notes MySQL 5.6

Sometimes is required have MySQL 5.6, an option is to use Docker, following is a template example

    version: '3.1'

    services:

      db:
        image: mysql:5.6
        command: --default-authentication-plugin=mysql_native_password
        restart: always
        ports:
            - 3306:3306
        environment:
          MYSQL_ROOT_PASSWORD: VkjFruG1b4i6MNuY
          MYSQL_DATABASE: jira_j71
          MYSQL_USER: jira_j71_admin
          MYSQL_PASSWORD: PCTmC4CtIgf5GJHm

    
