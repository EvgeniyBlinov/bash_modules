#!/bin/bash

if which pygmentize &> /dev/null; then
    alias ccat="$(which pygmentize) -g"
else
    echo 'For showing scripts need to install /usr/bin/pygmentize'
    echo 'apt-get update && apt-get install -y python-pygments'
    alias ccat='/bin/cat'
fi

function messageDeleteRead {
    echo -n "$1[y/N/r]"
    VERSION_FILE_NAME="$2"
    read key
    case "$key" in
        y)
            rm "$VERSION_FILE_NAME"
        ;;
        r)
            ccat "$VERSION_FILE_NAME"
            messageDeleteRead "$1" "$2"
        ;;
        n);;
        *)
            messageDeleteRead "$1" "$2"
        ;;
    esac
}

sf2doctrine_generate_repositories(){
    if [ -z "$1" ]; then
        echo 'Entity name required.'
        return 0;
    fi
    ENTITY_PATH="$1"
    if [ ! -f "$1" ]; then
        echo 'Entity class not found.'
        return 0;
    fi
    ENTITY_NAMESPACE="$(cat "$1"|head -5|grep namespace|sed -r 's/^[^n]*namespace\s+([^$;\s]+)[$;\s]+/\1/;s/;//')"
    ENTITY_NAME="$(cat "$1"|grep class|head -1|sed -r 's/^[^c]*class\s+([^$\{\s]+)[$\{\s]/\1/;s/\{//')"
    ENTITY_HAS_REPOSITORY="$(cat "$1"|grep '@ORM\\Entity(repositoryClass')"
    if [ -n "$ENTITY_HAS_REPOSITORY" ]; then
        echo "Entity $ENTITY_NAME has repository"
        return 0;
    fi
    ENTITY_REPOSITORY_STR="\(repositoryClass=\"$(echo $ENTITY_NAMESPACE|sed 's/\\/\\\\/')\\\\Repository\\\\${ENTITY_NAME}Repository\")"
    echo "$ENTITY_REPOSITORY_STR"
    eval $(echo "sed -i 's/@ORM\\\\Entity.*/@ORM\\\\Entity${ENTITY_REPOSITORY_STR}/'") "$1"
}

sf2doctrine_migration_show_last(){
    REVISION_NUMBER=`test -n "$1" && echo "$1" || echo 1`
    REVISION_HASHTAG="$(app/console doctrine:migrations:status --show-versions|tail -$(($REVISION_NUMBER))|head -1|grep -o '[0-9]\{14\}')"
    VERSION_FILE_NAME="./app/DoctrineMigrations/Version${REVISION_HASHTAG}.php"
    ccat "$VERSION_FILE_NAME"
}

sf2doctrine_migration_down(){
    REVISION_NUMBER=`test -n "$1" && echo "$1" || echo 1`
    REVISION_HASHTAG="$(app/console doctrine:migrations:status --show-versions|grep -v 'not migrated'|tail -$(($REVISION_NUMBER+1))|head -1|grep -o '[0-9]\{14\}')"
    app/console doctrine:migrations:migrate $REVISION_HASHTAG
}

sf2doctrine_migration_drop_not_migrated(){
    # REVISION_NUMBER=`test -n "$1" && echo "$1" || echo 1`
    REVISION_HASHTAGS="$(app/console doctrine:migrations:status --show-versions|
        grep 'not migrated'|
        grep -o '[0-9]\{14\}'|sort -r)"
        
    for REVISION_HASHTAG in $REVISION_HASHTAGS; do
        VERSION_FILE_NAME="./app/DoctrineMigrations/Version${REVISION_HASHTAG}.php"
        messageDeleteRead "Remove file ${VERSION_FILE_NAME}?" "$VERSION_FILE_NAME"
    done
}

#alias sf2doctrine_migration_down=sf2doctrine_migration_down
#alias sf2doctrine_migration_drop_not_migrated=sf2doctrine_migration_drop_not_migrated
