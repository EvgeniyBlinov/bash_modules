Bash functions and aliases.
============

Install

```sh
cat >> ~/.bashrc <<EOF

for bash_module in ~/.bash_modules/*.sh; do
    source \$bash_module
done

EOF
```
============
Module git.sh

`git_auto_commit` - Commit changes with message "Work stage YYYY-mm-dd HH:MM:SS"

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

- [See license](https://github.com/EvgeniyBlinov/bash_modules/blob/master/LICENSE)

### Author ###

- [Blinov Evgeniy](mailto:evgeniy_blinov@mail.ru) ([http://blinov.in.ua/](http://blinov.in.ua/))
