# CDX-Installer

This repo will install/setup the _CODEXium_ CORE service/software.

Use the script "install.sh" to setup/configure the software.

Use the script "update.sh" to update the software.

If you have purchased the software, you should have a license key.

* Copy your license key, as root, to ~/.ssh/ . 
* Copy the license key to the target file name .
* Change the mode to read-only on the original license key .  
  (You now have a backup key.)
* Change the mode to read-only on the target file name .

OR, you can just copy the following and run it.

e.g.
```
cp CODEXium-DeployKey-2025-Q4.key ~/.ssh/ ;
cp ~/.ssh/CODEXium-DeployKey-2025-Q4.key ~/.ssh/CODEXium-CORE.key ;
chmod 400 ~/.ssh/CODEXium-.DeployKey-2025-Q4.key ;
chmod 400 ~/.ssh/CODEXium-CORE.key ;
```

To get this CDX-Installer software ...

```
git clone https://github.com/codexium-io/CDX-Installer.git
```


