# CDX-Installer

This repo will install/setup the _CODEXium_ CORE service/software.

To get this CDX-Installer software ...

```
git clone https://github.com/codexium-io/CDX-Installer.git
```

If you have purchased the software, you should have a license key.

* Copy your license key, as root, to ~/.ssh/ . 
* Copy the license key to the target file name .
* Change the mode to read-only on the original license key .  
  (You now have a backup key.)
* Change the mode to read-only on the target file name .

OR, you can just copy the following and run it.

e.g.
```
cp CODEXium-CORE-DeployKey-2025-Q4.key ~/.ssh/ ;
cp ~/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ~/.ssh/CODEXium-CORE.key ;
chmod 400 ~/.ssh/CODEXium-CORE-DeployKey-2025-Q4.key ;
chmod 400 ~/.ssh/CODEXium-CORE.key ;
```

Now you can use the script "./install.sh" to setup the software.  
If you are installing on a new server dedicated to this software,
you can just accept all the prompts.
You may need to change the server name with the included script.

```
cd CDX-Installer ;
./install.sh ;
```

Let's change the domain to "example.com" ...

```
./change_site_name.sh
```

Then restart the webserver ...

```
systemctl restart httpd
```




