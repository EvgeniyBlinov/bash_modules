[![MIT License][license-image]][license-url]

Bash functions and aliases.
============

Install

```sh
cat >> ~/.bashrc <<EOF

if [ -d ~/.bash_modules/ ]; then
    for bash_module in ~/.bash_modules/*.sh; do
        source \$bash_module
    done
fi

EOF
```
============
Module git.sh

`git_auto_commit` - Commit changes with message "Work stage YYYY-mm-dd HH:MM:SS"

If branch has name: `2015-05-19_developer_taskId__description`

Commit massage should be: `[#taskId] master committed files`

============
Module grc.sh

Colorize terminal.

============
Module symfony2.sh for Symfony PHP framework. http://symfony.com/

`sf2doctrine_generate_repositories`         - doctrine -> generate repositories for current entity.
`sf2doctrine_migration_show_last`           - doctrine -> migrations -> show last migration.
`sf2doctrine_migration_down`                - dictrine -> migrations -> downgrade migrations.
`sf2doctrine_migration_drop_not_migrated`   - dictrine -> migrations -> manage(Read/Skip/Delete) not migrated migrations.


### License ###

[![MIT License][license-image]][license-url]

### Author ###

- [Blinov Evgeniy](mailto:evgeniy_blinov@mail.ru) ([http://blinov.in.ua/](http://blinov.in.ua/))

[license-image]: http://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license-url]: LICENSE
