# Dice-Assignment1
lambda function dice distribution simulation

roll_dice.py - python script to roll dice and sum the total and then summary how many times each total has occurred
variables.tf - terraform varirables
main.tf - main terraform file which create a lambda function and deploys the above python script.

Download the repository using git clone into a folder
Ensure you have access to AWS through access keys or token from the cli

Using terraform do the following

       terraform init
       
       terraform plan
       
       terraform apply
       (if it's all clear and there are no errors then say "yes" when prompted to do so)
       
When the above deployment is complete you can run the simlation by logging into the console and goto lambda and click on the function created above and click test with the following details

Saved Test Events - RollTheDice

To do a simulation of 100 throws with 3 dice and 6 sides , edit the JSON below and enter the following paramters

{
  "ndice": "3",
  "nsides": "6",
  "nthrows": "100"
 }

This will output json format to the screen and a file in the following s3 bucket with the output

s3://roll-the-dice0123456789/rolldice_output.txt



       
