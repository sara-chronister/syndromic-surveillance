library(keyring)

# enter your BioSense/ESSENCE username in the quotes where it says username01
# when you run this line, enter your password in the popup that appears
# this must be run at the beginning of each new session
# REMEMBER TO COMMENT OUT THIS LINE AFTER YOU RUN IT
# otherwise it will ask for your password every time

key_set(service = "essence", username)
