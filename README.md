sa-gitlab-runner
================

[![Build Status](https://travis-ci.org/softasap/sa-gitlab-runner.svg?branch=master)](https://travis-ci.org/softasap/sa-gitlab-runner)


Example of usage:

Simple

```YAML

     - {
         role: "sa-gitlab-runner"
       }


```

Advanced

```YAML

     - {
         role: "sa-gitlab-runner"
       }


```



Usage with ansible galaxy workflow
----------------------------------

If you installed the `sa-gitlab-runner` role using the command


`
   ansible-galaxy install softasap.sa-gitlab-runner
`

the role will be available in the folder `library/softasap.sa-gitlab-runner`
Please adjust the path accordingly.

```YAML

     - {
         role: "softasap.sa-gitlab-runner"
       }

```




Copyright and license
---------------------

Original code ideas - MIT copyright via  https://github.com/haroldb/ansible-gitlab-runner

Code is dual licensed under the [BSD 3 clause] (https://opensource.org/licenses/BSD-3-Clause) and the [MIT License] (http://opensource.org/licenses/MIT). Choose the one that suits you best.

Reach us:

Subscribe for roles updates at [FB] (https://www.facebook.com/SoftAsap/)

Join gitter discussion channel at [Gitter](https://gitter.im/softasap)

Discover other roles at  http://www.softasap.com/roles/registry_generated.html

visit our blog at http://www.softasap.com/blog/archive.html 
