# What are environment variables in Linux?

They are named key-value pairs stored by the OS that applications and shell processes use to configure their behavior and access system information. e.g.

-   PATH – tells the shell where to look for executable programs.
-   HOME – stores the current user's home directory.
-   USER – stores the current username.
-   SHELL – stores the path to the user's default shell.

```
SHELL=/bin/bash
HOME=/home/funmi
USER=funmi
```

## How to access environment variables on the system
-   use the `printenv` command to view all the environment variables that your system currently has.

```
printenv
printenv | less
```

-   For printing specific variable:
```
printenv USER
printenv | grep USER
```

-   Environment variable can be referenced as another variable:

```
echo $USER
echo $NAME
echo $HOME
```
## Application Environment Variables
These are environment variables that we usually create by ourselves to work with applications to provide some configuration values at runtime without having to hardcode them into the application's source code. e.g. 
-   DATABASE_URL – database connection string.
-   API_KEY – API authentication key.
-   PORT – port the application should listen on.
-   LOG_LEVEL – logging verbosity (e.g., INFO, DEBUG).
-   JWT_SECRET – secret used for signing JWTs.

With application environment variable, we are able to store different settings to cater to different environments such as development, testing, and production.

## How to create environment variable

```
export DB_USERNAME=dbuser
export DB_PASSWORD=secretpass
export DB_NAME=mydb
```

To check:

```
printenv | grep DB

echo $DB_NAME
```

## Deleting environment variables
Environmrnt variables are unset or deleted by using the command below:

```
unset DB_NAME
printenv | grep DB
```

Note that whenever variables are set with the export command, they are not persistent data. As soon as the terminal/bash session is closed, all the variables that were set before will be wiped out. To avoid this, you will have to enter the values into the `/home/user/.bashrc` file.

Variables set in this file are loaded whenever a bash login shell is entered. So, in the `.bashrc` file, you'll add the variables like so:

```
export DB_USERNAME=dbuser
export DB_PASSWORD=secretpass
export DB_NAME=dbuser
```
Afterwards, save and close the file. However, you have to reload the bash configuration (`.bashrc`) file with the following command to activate the changes you just added.

```
source .bashrc
```

## How to add a custom command/program

1. Create a script, for example, [welcome](./welcome)
2. Grant the script execute permission, (chmod a+x welcome)
3. We need to define a path to our custome file in the `.bashrc` file.

> vim ~/.bashrc

In the `.bashrc` file, add `PATH=$PATH:/home/user/` to the file. Note that the absolute path may be monger than `/home/user/` depending on the location of the script that was created. 

> source ~/.bashrc
This reloads the Bash configuration file into the current terminal session. This enables it to apply changes such as new environment variables, aliases, or PATH updates without requiring you to close and reopen the terminal. 

4. Change directory, cd, into a folder where the script is not in and execute the script (The previous steps helped us configure it globally).

5. Execute the script by just typing the name on the CLI.

> welcome

![Welcome Script](./images/welcome-script.png)


It should execute the script