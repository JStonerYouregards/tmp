@un_dev_host = "ec2-54-221-46-31.compute-1.amazonaws.com"

role :web, @un_dev_host
role :app, @un_dev_host
role :db,  @un_dev_host, :primary => true
role :db,  @un_dev_host
