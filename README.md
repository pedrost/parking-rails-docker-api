# - Parking app - Teste MLabs
Rails Parking app it is a simple API to register entries and outs of parkings using ruby on rails. 

## Dependencies
- [Docker](https://docs.docker.com/get-docker/)
- [Docker-compose](https://docs.docker.com/compose/install/)

## Setup app
* First run `sudo docker-compose build` to setup containers
* Then run `sudo docker-compose run app bundle exec rake db:create db:migrate --trace` to setup database

## Running specs 
* Just run `sudo docker-compose run app bundle exec rspec`

## Usage
* Deploy app by running `sudo docker-compose up`
* App must be runing on `localhost:3000`

## API Docs
You can find the Postman Docs for this app [here](https://documenter.getpostman.com/view/11534037/SztBa7c9?version=latest)
