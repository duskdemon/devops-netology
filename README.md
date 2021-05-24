# devops-netology
02-git-04-tools

Клонируем репозиторий терраформа:

git clone https://github.com/hashicorp/terraform
cd terraform

1. Найдите полный хеш и комментарий коммита, хеш которого начинается на aefea

$ git log aefea
commit aefead2207ef7e2aa5dc81a34aedf0cad4c32545
Author: Alisdair McDiarmid <alisdair@users.noreply.github.com>
Date:   Thu Jun 18 10:29:58 2020 -0400

    Update CHANGELOG.md

Ответ: aefead2207ef7e2aa5dc81a34aedf0cad4c32545 Update CHANGELOG.md

2.Какому тегу соответствует коммит 85024d3?

$ git log 85024d3
commit 85024d3100126de36331c6982bfaac02cdab9e76 (tag: v0.12.23)

Ответ: v0.12.23

3.Сколько родителей у коммита b8d720? Напишите их хеши.

$ git show b8d720
commit b8d720f8340221f2146e4e4870bf2ee0bc48f2d5
Merge: 56cd7859e 9ea88f22f
Author: Chris Griggs <cgriggs@hashicorp.com>
Date:   Tue Jan 21 17:45:48 2020 -0800

Ответ: 2 родителя: хэши 56cd7859e 9ea88f22f

4.Перечислите хеши и комментарии всех коммитов которые были сделаны между тегами v0.12.23 и v0.12.24.

$ git log --pretty=oneline v0.12.23...v0.12.24 --pretty=format:"%H"
33ff1c03bb960b332be3af2e333462dde88b279e
b14b74c4939dcab573326f4e3ee2a62e23e12f89
3f235065b9347a758efadc92295b540ee0a5e26e
6ae64e247b332925b872447e9ce869657281c2bf
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353
06275647e2b53d97d4f0a19a0fec11f6d69820b5
d5f9411f5108260320064349b757f55c09bc4b80
4b6d06cc5dcb78af637bbb19c198faff37a066ed
dd01a35078f040ca984cdd349f18d0b67e486c35
225466bc3e5f35baa5d07197bbc079345b77525e

Ответ:
b14b74c4939dcab573326f4e3ee2a62e23e12f89
3f235065b9347a758efadc92295b540ee0a5e26e
6ae64e247b332925b872447e9ce869657281c2bf
5c619ca1baf2e21a155fcdb4c264cc9e24a2a353
06275647e2b53d97d4f0a19a0fec11f6d69820b5
d5f9411f5108260320064349b757f55c09bc4b80
4b6d06cc5dcb78af637bbb19c198faff37a066ed
dd01a35078f040ca984cdd349f18d0b67e486c35
225466bc3e5f35baa5d07197bbc079345b77525e

5.Найдите коммит в котором была создана функция func providerSource, ее определение в коде выглядит так func providerSource(...) (вместо троеточего перечислены аргументы).

Находим файл, в котором определена функция

$ git grep -p 'func providerSource'
provider_source.go=import (
provider_source.go:func providerSource(configs []*cliconfig.ProviderInstallation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {
provider_source.go=func implicitProviderSource(services *disco.Disco) getproviders.Source {
provider_source.go:func providerSourceForCLIConfigLocation(loc cliconfig.ProviderInstallationLocation, services *disco.Disco) (getproviders.Source, tfdiags.Diagnostics) {

Ищем коммит, в котором добавлен этот файл

$ git log --diff-filter=A -- provider_source.go
commit 8c928e83589d90a031f811fae52a81be7153e82f
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Thu Apr 2 18:04:39 2020 -0700

Ответ: 8c928e83589d90a031f811fae52a81be7153e82f

6.Найдите все коммиты в которых была изменена функция globalPluginDirs.

Ищем файл, в котором введена функция

$ git grep -p 'func globalPluginDirs'
plugins.go=import (
plugins.go:func globalPluginDirs() []string {

Это файл plugins.go
Ищем коммиты, в которых функция изменялась

$ git log -L :globalPluginDirs:plugins.go | grep commit
commit 78b12205587fe839f10d946ea3fdc06719decb05
commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46
commit 41ab0aef7a0fe030e84018973a64135b11abcd70
commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17
commit 8364383c359a6b738a436d1b7745ccdce178df47

Это коммит, в котором добавлен файл plugins.go, то есть в нем изначально появилась функция, поэтому он исключается из ответа

$ git log --diff-filter=A -- plugins.go
commit 8364383c359a6b738a436d1b7745ccdce178df47
Author: Martin Atkins <mart@degeneration.co.uk>
Date:   Thu Apr 13 18:05:58 2017 -0700

Ответ:
commit 78b12205587fe839f10d946ea3fdc06719decb05
commit 52dbf94834cb970b510f2fba853a5b49ad9b1a46
commit 41ab0aef7a0fe030e84018973a64135b11abcd70
commit 66ebff90cdfaa6938f26f908c7ebad8d547fea17

7.Кто автор функции synchronizedWriters?

Ищем файл, в котором введена функция

$ git grep -p 'func synchronizedWriters'

Не нашел... Поиск строки тоже не очень помог

$ git grep -ni synchronized
internal/instances/expander.go:23:// Expander is a synchronized object whose methods can be safely called
website/upgrade-guides/0-12.html.markdown:65:  synchronized.
website/upgrade-guides/0-12.html.markdown:132:synchronized with the latest configuration.
website/upgrade-guides/0-12.html.markdown:138:`terraform apply` to ensure that everything is initialized and synchronized.

Поиск гуглом на гитхабе вывел на файл, автором которого является Martin Atkins:

https://github.com/koding/terraform/blob/master/synchronized_writers.go

Ответ: Martin Atkins
