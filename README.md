sa-gitlab-runner
================

[![Build Status](https://travis-ci.org/softasap/sa-gitlab-runner.svg?branch=master)](https://travis-ci.org/softasap/sa-gitlab-runner)


Example of usage:

Simple

```YAML

     - {
         role: "sa-gitlab-runner",
         gitlab_runner_registration_token: 'xxx-yyyy'
       }


```

Advanced

```YAML
vars:
  - custom_config_toml_properties:
roles:  
     - {
         role: "sa-gitlab-runner",
         # GitLab coordinator URL
         gitlab_runner_coordinator_url: 'https://gitlab.com/ci',
         # GitLab registration token
         gitlab_runner_registration_token: 'xxx-yyyy',
         # Runner description
         gitlab_runner_description: 'Some runner desc',
         # Runner executor
         gitlab_runner_executor: 'shell', # docker
         # Default Docker image
         gitlab_runner_docker_image: 'someimage',
         # Runner tags
         gitlab_runner_tags: ['node', 'ruby', 'mysql']         
       }
```



Usage with ansible galaxy workflow
----------------------------------

If you installed the `sa-gitlab-runner` role using the command


`
   ansible-galaxy install softasap.sa_gitlab_runner
`

the role will be available in the folder `library/softasap.sa_gitlab_runner`
Please adjust the path accordingly.

```YAML

     - {
         role: "softasap.sa_gitlab_runner"
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
