[![Lifecycle:Retired](https://img.shields.io/badge/Lifecycle-Retired-d45500)](https://github.com/bcgov/repomountie/blob/master/doc/lifecycle-badges.md)

# bcdc-devops
Developer Template for BCDC

# Vanilla Ckan
Each directory labeled 'ckan-x.x.x' is an install for that specific version of ckan.

Instructions and deatils are provided in the README.md file for each version.

# Do not use these installs for production!
- these installs are for development purposes **only**.

# Change log
## 2016/10/03 - Removing ckan versions 2.3.x and 2.4.x, various changes to master
- v2.3.x & v2.4.x
    - Gone, not necessary anymore

- master
    - update centos box to 6.8
    - updated ckan-init.sh, should be able to just run the script
    - Updated provision.sh
        - added Redis v3.2.4 (source install)
        - updated Python to v2.7.12
        - added Nodejs/npm from offical yum repo
        
- v2.5.x
    - update centos box to 6.8

## 2016/05/02 - Adding ckan versions 2.4.3, 2.5.2 and master vagrant installs
- v2.3.x
    - running ckan version 2.3.4
    - python version was incorrect, changed to python-2.7.8
    - export variables added to `~/.bashrc` file
    - ckan and extensions now sync to the `ckan-2.3.x/src` folder after installation is complete
    - all extensions are installed via pip 'git+'
    - README.md
        - Removed logged in commands
        - changed version number

- v2.4.x
    - added
    - running ckan version 2.4.3
    - ckan and extensions now sync to the `ckan-2.4.x/src` folder after installation is complete
    - all extensions are installed via pip 'git+'
    - README.md
        - Removed logged in commands
        - changed version number

- v2.5.x
    - added
    - running ckan version 2.5.2
    - ckan and extensions now sync to the `ckan-2.5.x/src` folder after installation is complete
    - all extensions are installed via pip 'git+'
    - README.md
        - Removed logged in commands
        - changed version number

- master
    - Note: ckan master install is broken, as of this commit, until wsgi_party v0.1b1 is in pypi
        - but if you need the master install, go into the requirements.txt file, comment out `wsgi_party`, install the requirements, then use this command: `pip install 'git+https://github.com/rduplain/wsgi_party@v0.1b1#egg=wsgi_party'`
    - added
    - running ckan version master
    - ckan and extensions now sync to the `master/src` folder after installation is complete
    - all extensions are installed via pip 'git+'
    - README.md
        - Removed logged in commands
        - changed version number
