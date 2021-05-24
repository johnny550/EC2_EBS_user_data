This code

-> Spins up an instance

-> Attaches a created EBS volume at launch through user data
  
  -> The user data is defined in the file cloudinit.tf
     Script files are called in cloudinit.tf. The output of the latter is referenced through user-data in instances.tf
     
     -> The script volumes.sh will allow us to reuse the same EBS volume for another instance even if the instance it was attached to previously has been terminated
