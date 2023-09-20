# Implementation Template

## Run Development Server
```bash
bin/vite dev
```

```bash
rails s
```

---
## Configuration
* Initial Config
```bash
bundle install
```
```bash
yarn install
```
```bash
cp .env-example .env
```
And replace the variables to match your configuration

Remember change the database index for shared implementations


* SDK Configuration

Change the host and its credentials to the CaliforniaXF instance

Enable Redis !!!!!

-Tips


For better image performance you can use the sdk public_assets_controller.rb, and call it just pointing the source to `/public_assets/slug`

If there is missing a specific method you would need to use, you can use the @mints.client.raw _for more information check the gem github https://github.com/rubengomez/mints-ruby-sdk/blob/master/lib/client.rb_

* CaliforniaXF Configuration

Seeder:

Run the seeds for the landing page
```rake seeder:production```

* CDN Config

* Monitoring Configuration

Configure a space webhook for google notifications


* Databases

`
Mongo
`

`
Redis
`

---

## Version Control

Use `gitflow`

`TODO: Explain more about gitflow and add the most used commands`

---
## Dependencies

* Ruby version
`
Equal or superior to: 3.0
`

* Rails
`
7.0.4
`

* Vite 
`
4.1.1
`

* Vue
  `
  3.2.47
  `
* Node
  `
  16.14.0
  `
---
## Testing
* Rspec

Version: 
```
rspec spec/jobs
```
---

*TODO:*

Install Rspec

Document Deployment

---

# Ruby 2.7 to 3.0 migration
```ruby
  # Change: Positional arguments and keyword arguments will be separated now.
  # Before:
  def foo(*args, &block)
    target(*args, &block)
  end

  # Now: You need to explicitly delegate keyword arguments.
  def foo(*args, **kwargs, &block)
  target(*args, **kwargs, &block)
  end
```

Arguments forwarding (…) now supports leading arguments
```ruby
  def method_missing(meth, ...)
    send(:"do_#{meth}", ...)
  end
```


Change: Endless method definition is added.
```ruby
  def square(x) = x * x
```

Hash#except is now built-in.

```ruby
h = { a: 1, b: 2, c: 3 }
p h.except(:a) #=> {:b=>2, :c=>3}
```

---

# Components documentation

<br>

---
# Cali Dynamic form:
The component allows you to render different fields dynamically and asynchronously, this so that only the files that the form actually uses are not downloaded,
so you don't have to worry if everything is imported for a simple text, in addition to creating the validations according to the rules added in the
CXF instance and depending on the type of data it is, for example, if it is a telephone number, it will validate the maskedNumber, etc.

Once the project is installed, you can import the component as follows

```js
import DynamicForm from "@components/cali-dynamic-form/App.vue";

export default {
  components: { DynamicForm }
}
```

Usage example:

```vue
<template>
   <div class="container-fluid">
     <div class="row justify-content-center">
       <div class="col-8">

         <DynamicForm
                 v-if="form"
                 :data="form"
                 @onSubmit="onSubmit"
                 @onCancel="onCancel"/>

       </div>
     </div>
   </div>
</template>

<script>
import DynamicForm from "@components/cali-dynamic-form/App.vue";

export default {
   components: { DynamicForm },

   data: () => ({ form: null }),

   mounted() {
     this.getForm();
   },

   methods: {
     async getForm() {
         const options = {
             method: "GET",
             headers: {
                 Accept: "application/json",
                 "Content-Type": "application/json",
                 'ApiKey': '45NjIjKPAwfc3ArbbbwY8NoI8PltBZeRxbETQY4ZlBRvFBn3LRz5vJmomTYq'
             },
         };

         const api = 'https://staging.mints.cloud/api/v1/content/forms/contact-form'

         fetch(api, options)
             .then(response=>response.json())
             .then(data=> {
                 this.form = data.data;
             })
     },

     onSubmit(answers, response) {
       console.log("Answers filled by the user:", answers);
       console.log("Api response:", response);
     },

     onCancel() {
       console.log("Submission cancelled")
     }
   }
}

</script>
```

## Props API

| Props    | Type    | Required | Default |
|----------|---------|----------|---------|
| v-model  | Object  | yes      | -       |
| data     | Object  | yes      | -       |
| readonly | Boolean | no       | false   |

## Events

| Event    | Return                                           |
|----------|--------------------------------------------------|
| onSubmit | Response from the api and all the answers filled |
| onCancel | Submission has been canceled                     |

## Injections

| Injections | Type    | Required | Default |
|------------|---------|----------|---------|
| $contact   | Object  | no       | {}      |

> **Note**
> When you want the form to pre-fill the contact data, it will be necessary
> to provide the $contact variable so that the DynamicForm is able to recognize it.
>
> *Example:*
> ```js 
> export default {
>  provide() {
>   return {
>     $contact: computed(()=> this.contact )
>   }
>  },    
> }
> ```

---

# Cali login:
The CaliLogin component allows you to add a quick login either via magic link or credentials, and even with both, for this you need to configure it correctly.
To import it you need to add the following line:

```js
import CaliLogin from '@components/cali-login/App.vue';
export default {
  components: { CaliLogin }
}
```

Usage example:

```vue
<template>
  <CaliLogin
    :options="{
      magicLink: { enabled: true, url: '/api/v1/login'},
      password: { enabled: true, url: '/api/v1/login' },
      headers: {
        'x-api-key': '9c6334a7-8215-46ff-8ec9-f442cdc43cac'
      }
    }"
          @onSubmit="onSubmit"
          @onError="onError"
  />
</template>

<script>
import CaliLogin from '@components/cali-login/App.vue';

export default {
  components: { CaliLogin },
  methods: {
    onSubmit(response) {
      let title = 'Magic link enviado'
      let text = 'Se ha enviado el magic link...'

      if (response.type === 'password') {
        title = 'Autenticación correcta'
        text = 'Iniciando sesión...';

        setTimeout(() => {
          window.location.href = '/'
        }, 1500)
      }

      this.sendAlert('success', title, text)
    },

    onError(e) {
      this.sendAlert('error', 'Oops...', 'Credenciales inválidas.')
    },

    sendAlert(icon, title, text) {
      this.$swal.fire({
        icon: icon,
        title: title,
        text: text
      })
    }
  }
};
</script>


```

## Props API

| Props   | Type   | Required | Default                                 |
|---------|--------|----------|-----------------------------------------|
| options | Object | no       | [See options](#markdown-header-options) |

## Events

| Event    | Return                                               |
|----------|------------------------------------------------------|
| onSubmit | Response given by the api when the status is success |
| onError  | Error given by the api                               |

## Options

To avoid too many properties, we decided to add the options property, which includes the configuration of the component, either the api's to query, the login types that will be enabled and the headers that they will send.
The default value for this object is:

```js
{
  magicLink: { enabled: true },
  password: { enabled: true },
  headers: {
    Accept: "application/json",
            "Content-Type": "application/json"
  }
}
```

Recommended configuration:
```js
{
  magicLink: { enabled: true, url: 'your api link' },
  password: { enabled: true, url: 'your api link' },
  headers: { /* Insert your headers here, the default headers allways are merged but you can override them*/ }
}
```

---

# Cali modal:
The CaliModal component allows you to implement a modal in a simple way, already including a template where what you modify is the header, footer or the body

```js
import CaliModal from '@components/cali-modal/App.vue';
export default {
  components: { CaliModal }
}
```

Usage example:

```vue
<template>
  <CaliModal ref="ModalDelete" v-if="isOpen" modalSize="md" @close="close">
    <template v-slot:header>
      <h4 class="modal-title" id="exampleModalLabel">Remove product</h4>
    </template>
    
    <template v-slot:body>
      <div class="ps-1">
        <span class="font-delete">
          Are you sure you want to delete the product?
          <br>
          This action can not be undone.
        </span>
      </div>
    </template>
    
    <template v-slot:footer>
      <button type="button" class="btn btn-secondary" @click="close">Cancelar</button>
      <button type="button" class="btn btn-primary ms-1" @click="remove">
        Remove
      </button>
    </template>
  </CaliModal>
</template>

<script>
import CaliModal from "@components/cali-modal/App.vue";

export default {
  components: { CaliModal },
  data: () => ({
    isOpen: false,
  }),
  
  methods: {
    open(row, story) {
      this.isOpen = true;
    },
    close() {
      this.isOpen = false;
    },
    remove() {
      // code here...
    }
  }
}
</script>
```

or without header slot:

```vue
<template>
  <CaliModal ref="ModalDelete" v-if="isOpen" modalSize="md" title="Remove product" @close="close">
  <!-- Code here ...--->
```

## Props API

| Props           | Type   | Required | Default                  |
|-----------------|--------|----------|--------------------------|
| title           | String | no       | null                     |
| modalSize       | String | no       | md (sm, md, lg, xl)      |
| closeModalImage | Object | no       | { src: null, alt: null } |

## Events

| Event | Return                             |
|-------|------------------------------------|
| close | Component has been clicked outside |

---

# Cali permissions UI:
Cali Permissions UI allows you to implement the verification of permissions by module, this in turn is used for components as well as for functions

If you want to implement the component to check permissions, import it as follows:
```js
<template>
  <Can I="read" a="post">
    Yeah, i can read a post!
  </Can>
</template>

import { Can } from '@components/cali-permissions-ui/App.vue';
export default {
  components: { Can }
}
```

Otherwise, if what you want is to check in some method if it complies with the permissions, you can import it as in the following example:
```js
import { verifyPermission } from '@components/cali-permissions-ui/App.vue'

export default { 
  methods: {
    verify() {
      return verifyPermission('view', 'post')
    }
  }
}
```

Keep in mind that this component stores the permissions in a store (pinia), so you have to initialize the component properly, example:

```js
import { permissionsBuilder } from "@components/cali-permissions-ui/App.vue";

export default {
  mounted() {
    const { initialize } = permissionsBuilder()
    initialize.value([{
      title: "Post"
      id: "post:view",
    },{
      title: "Comments",
      id: "comments:edit",
    },{
      title: "Profile",
      id: "profile:all",
    }])
  }
}
```

> **Note**
> The permissions are made up of two parts, the first is the related module and the second is what permission it has, for example:
> <br> <br>
> post:edit
> <br> <br>
> Here we indicate that you have permission to edit a post, if we want to declare that you have all the permissions of a post, it will be necessary to indicate it as follows:
> <br> <br>
> post:all
> <br> <br>
> If you don't want to use the word "all", you can set another one.

Usage example:

```vue
<template>
  <main>
    <Can I="read" a="post">
      <article> <!-- Your post --> </article>
    </Can>

    <Can I="edit" a="post">
      <button class="btn btn-success" @click.prevent="edit"></button>
    </Can>
    
    <OtherComponent />
  </main>
</template>

<script>
import { Can, permissionsBuilder } from '@components/cali-permissions-ui/App.vue';
import OtherComponent from './OtherComponent.vue';
export default {
  components: { Can, OtherComponent }
  
  methods: {
    edit() {
      // code here...
    }
  },

  mounted() {
    const { initialize } = permissionsBuilder()
    initialize.value([{
      title: "Post"
      id: "post:view",
    },{
      title: "Post / Comment",
      id: "post:comment",
    },{
      title: "Post / Rating",
      id: "post:rating",
    }])
  }
}
</script>
```

OtherComponent:

```vue
<template>
  <Can I="rating" a="post">
    <!-- Your rating component -->
  </Can>
</template>

<script>
import { Can } from '@components/cali-permissions-ui/App.vue';

export default {
  components: { Can }
}
</script>
```

> **Note**
> You don't need to initialize the permissions twice, it's enough to do it once since it is stored in the store

## Can component Props API

| Props          | Type   | Required | Default |
|----------------|--------|----------|---------|
| I (permission) | String | yes      | -       |
| A (module)     | String | yes      | -       |

## Function verifyPermission

| Parameters     | Type   | Required | Default |
|----------------|--------|----------|---------|
| I (permission) | String | yes      | -       |
| A (module)     | String | yes      | -       |

Usage example:
```js
import { verifyPermission } from "@components/cali-permissions-ui/App.vue";

export default {
  mounted() {
    if (verifyPermission('view', 'post')) {
      console.log("Yeah!, i can read a post")
    }
  }
}
```

Or if you want to add multiple conditions you can do something like this:
```js
import { verifyPermission } from "@components/cali-permissions-ui/App.vue";

export default {
  mounted() {
    // Check if I can see or edit a post
    if (verifyPermission('view|edit', 'post')) {
      console.log("Yeah!, i can read a post")
    }

    // Check if I can see and edit a post
    if (verifyPermission('view&edit', 'post')) {
      console.log("Yeah!, i can read a post")
    }
    
    // you can add the conditions you want
    if (verifyPermission('view|edit|imOwner&isPublished', 'post')) {
      console.log("Yeah!, i can read a post")
    }
  }
}
```

## Permissions Builder

| Attributes  | Type   | Returns                    |
|-------------|--------|----------------------------|
| permissions | Array  | All permissions stored     |
| config      | Object | Gives the component config |

Usage example:

```js
import { permissionsBuilder } from "@components/cali-permissions-ui/App.vue";

export default {
  mounted() {
    const { permissions, config } = permissionsBuilder()

    // Print all permissions: [{ title: "Post", id: "post:view" }]
    console.log(permissions) 
    
    // Print the component config: { hasAllPermissionsWord: 'all' }
    console.log(config)
  }
}
```

| Methods           | Action                                                         |
|-------------------|----------------------------------------------------------------|
| initialize        | Build all the permissions given and store all of them          |
| changeConfig      | Change the component config ({ hasAllPermissionsWord: 'all' }) |
| attachPermissions | Add permissions to the store                                   |
| removePermissions | Remove permissions from the store                              |

Usage example:

```js
import { permissionsBuilder, changeConfig } from '@components/cali-permissions-ui/App.vue';
export default {
  mounted() {
    const { initialize, changeConfig, attachPermissions, removePermissions } = permissionsBuilder()
    
    initialize.value([{
      title: "Post"
      id: "post:view",
    },{
      title: "Post / Comment",
      id: "post:comment",
    }])

    // Change component config
    changeConfig.value({ hasAllPermissionsWord: 'everything' })

    // Concat new permissions to existing permissions
    // Are four ways to attach new permissions
    attachPermissions.value([{ title: "Post / Comment", id: "post:comment",}])
    attachPermissions.value({ title: "Post / Comment", id: "post:comment",})
    attachPermissions.value(["post:comment"])
    attachPermissions.value("post:comment")

    // Remove permissions to existing permissions
    // Are four ways to remove permissions
    removePermissions.value([{ title: "Post / Comment", id: "post:comment",}])
    removePermissions.value({ title: "Post / Comment", id: "post:comment",})
    removePermissions.value(["post:comment"])
    removePermissions.value("post:comment")
  }
}
```
---

# Cali searchable list:
Cali Searchable List allows you to create a searchable list, in addition to being able to choose cases where multiple selections are required, on the other hand, the component is prepared to be client side as well as server side, so you can add it to point to an api to obtain the options.
```js
import CaliSearchableList from '@components/cali-searchable-list/App.vue';
export default {
  components: { CaliSearchableList }
}
```

Usage example:

```vue
<template>
  <CaliSearchableList
          v-model="selectedOption"
          :options="options"
  />
</template>

<script>
import CaliSearchableList from '@components/cali-searchable-list/App.vue';

export default {
  components: { CaliSearchableList },
  data: () => ({
    selectedOption: '',
    options: ['apple', 'pineapple', 'watermelon'],
  }),

}
</script>
```

if you want to make server side this component:

```vue
<template>
  <CaliSearchableList
          v-model="selectedOption"
          :options="options"
          :config="{
      multiple: true,
      loadingText: 'Loading...',
      noChoicesText: 'No results found',
    }"
  />
</template>

<script>
import CaliSearchableList from '@components/cali-searchable-list/App.vue';
import axios from 'axios';

export default {
  components: { CaliSearchableList },
  data: () => ({
    selectedOption: [],
    options: ['apple', 'pineapple', 'watermelon'],
  }),

  methods: {
    // Filters includes search param as string.
    async getOptions(filters) {
      const headers = {
        Accept: "application/json",
        "Content-Type": "application/json",
      };

      const api = 'https://your-api-url'
      const response = await axios.get(api + '?' + filters, headers)

      return response.data
    }
  }

}
</script>
```

## Props API

| Props   | Type              | Required | Default                               |
|---------|-------------------|----------|---------------------------------------|
| v-model | [String, Array]   | yes      | -                                     |
| options | [Function, Array] | no       | []                                    |
| config  | Object            | no       | [See Config](#markdown-header-config) |

## Config
To avoid too many properties, we decided to add the config property, which includes the configuration of the component, such as whether it is multiple, placeholder, whether it can remove items, whether it can search items, etc.
The default value for this object is:

```js
{
  placeholder: null,
          multiple: false,
          removeItems: false, // indicate if the user can clean the selected values
          search: true,
          loadingText: 'Loading...',
          noChoicesText: 'No results found',
          disabled: false,
          loading: false,
}
```

---

# Cali server table:

Cali server table provides the ability to generate server side tables, controlling the objects received and providing methods to keep the data updated, includes base filters and the ability to customize the filters you want, in addition to deciding how to print the values
```js
import CaliServerTable from '@components/cali-server-table/App.vue';
export default {
  components: { CaliServerTable }
}
```

Usage example:

```vue
<template>
  <CaliServerTable
    ref="serverTable"
    :options="{
      api: '/my-api-url',
      search: true,
      headers: ['id', 'name', 'last name'],
    }"
  >
</template>

<script>
import CaliServerTable from '@components/cali-server-table/App.vue';

export default {
  components: { CaliServerTable },
}
</script>
```

## Props API

| Props   | Type   | Required | Default                             |
|---------|--------|----------|-------------------------------------|
| id      | Number | no       | 1                                   |
| options | Object | no       | [See Table Options](#Table Options) |

## Table Options
To avoid having too many properties, we made the configuration an object, where you can manipulate as much of the component as possible.
The default value of this prop is the following:

```js
{
  download: {},
  create: {},
}
```

Full config object

```js
{
  api: String,
  objectType: String,
  searchPlaceholder: String,
  search: { type: Boolean, default: true },
  headers: Array,
  defaultFilters: Object,
  download: {
    type: Object,
    default: () => ({}),
    text: String,
    onClick: Function,
    loading: Boolean
  },
  create: {
    type: Object,
    default: () => ({}),
    text: String,
    onClick: Function
  },
}
```

## Config Parameters

| Props             | Type     | Required | Details                                                           |
|-------------------|----------|----------|-------------------------------------------------------------------|
| api               | String   | no       | Indicates the api for this server table                           |
| objectType        | String   | no       | Indicates the object type for this records, for example: contacts |
| searchPlaceholder | String   | no       | Indicates the placeholder for search input                        |
| search            | Boolean  | no       | Indicates if the component will have search input                 |
| headers           | Array    | no       | Indicates the headers for the table                               |
| defaultFilters    | Object   | no       | Indicates the default filters when the api is called              |
| download          | Object   | no       | Indicates if the table has download button, like generate report  |
| download.text     | String   | no       | Indicates if the text for the download button                     |
| download.onClick  | Function | no       | Indicates the callback when the button is clicked                 |
| download.loading  | Boolean  | no       | Indicates if the download action is loading                       |
| create            | Object   | no       | Indicates if the table has create button, like generate report    |
| create.text       | String   | no       | Indicates if the text for the create button                       |
| create.onClick    | Function | no       | Indicates the callback when the button is clicked                 |
| create.loading    | Boolean  | no       | Indicates if the create action is loading                         |

## Methods

| Function               | Details                                           | Parameters                                         |
|------------------------|---------------------------------------------------|----------------------------------------------------|
| removeObject           | Removes the indicated object from the table       | id                                                 |
| updateObject           | Update table record                               | payload, key, method = null, isMongoRecord = false |
| refresh                | Refresh records data (this make another api call) | -                                                  |
| updateMultiplesObjects | Update multiples records                          | objectsIds, key, method                            |
| removeObjectRelation   | Remove related relationship                       | id, relationId, relation                           |


Usage example:

```vue
<template>
  <CaliServerTable
    ref="serverTable"
    :options="{
      api: '/my-api-url',
      search: true,
      headers: ['id', 'name', 'last name'],
    }"
  >
</template>

<script>
import CaliServerTable from '@components/cali-server-table/App.vue';

export default {
  components: { CaliServerTable },
  
  mounted() {
    // Remove the record with id 1
    this.$refs.serverTable.removeObject(1);

    // Update the field email for the requested record (the new email comes from the record parameter)
    this.$refs.serverTable.updateObject(record, 'email');

    // Update the record depending on the method passed
    this.$refs.serverTable.updateObject(record, null, function(record) {
      // Proccess record here...

      return record
    });

    // Update the email, and indicates that the record comes from mongo
    // this allows to search by mongo id (record._id.$oid)
    this.$refs.serverTable.updateObject(record, 'email', null, true);
    
    // Refresh all records
    this.$refs.serverTable.refresh();

    // Update records with id 1 and 2
    // In this case updates the new email by the key parameter
    // The new email will be the passed in the records
    this.$refs.serverTable.updateMultiplesObjects(
      [{ id: 1, email: 'new_email@email.com'}, { id: 1, email: 'new_email2@email.com'}],
      'email'
    );

    // Update records with id 1 and 2
    // In this case updates the record depending in the function
    this.$refs.serverTable.updateMultiplesObjects(
      [{ id: 1, email: 'new_email@email.com'}, { id: 1, email: 'new_email2@email.com'}],
      null,
      function (record) {
        // Proccess record here...
        return record
      }
    );

    // Remove related relationship for one record
    // in this case remove the relationship with id '5' in the 'posts' relationship
    // from the record with id 1
    this.$refs.serverTable.removeObjectRelation(
      1, // recordId
      5, // relationId
      'posts' // relation
    );
  }
}
</script>
```
---

# Cali workflow:
This component allows you to easily render a workflow that illustrates the indicated steps, in which step you are currently in.

Example of how to import it
```js
import CaliWorkflow from '@components/cali-workflow/App.vue';
export default {
  components: { CaliWorkflow }
}
```

Usage example:

```vue
<template>
  <CaliWorkflow :items="items" :active-step="activeWorkflowItem"/>

</template>

<script>
import CaliWorkflow from '@components/cali-workflow/App.vue';
export default {
  components: { CaliWorkflow },
  
  /*
    The items can be the following attributes:
    
      title: Is the step title, in this case only works with strings
      
      description: Is the step description, can be string or function
      
      iconHTML: It is the icon that represents the current step
      
      activeIconHTML: It is the icon that represents the current step when it is active,
                      when the activeStep is equal to the step index
   */
  
  data: () => ({
    items: [{
      title: 'Step 1',
      description: 'The step 1 show when the contact has subscribed recently',
      iconHTML: '<i class="fas fa-cog"></i>',
      activeIconHTML: '<i class="fas fa-check-circle green"></i>'
    }, {
      title: 'Step 2',
      // Description can be function or string
      description: () => (
        'The step 2 show when the contact has subscribed more than 5 times'
      ), 
      iconHTML: '<i class="fas fa-cog"></i>',
      activeIconHTML: '<i class="fas fa-check-circle green"></i>'
    }],
    activeWorkflowItem: 0 // Is the index for the current step from items
  })
}
</script>
```

## Props API

| Props      | Type   | Required | Default |
|------------|--------|----------|---------|
| items      | Array  | no       | []      |
| activeStep | Number | no       | 1       |


---

# JS Helpers documentation

## Axios provider
The Axios Provider allows you to generate an axios instance with the headers already instantiated, in addition to adding the base url and each time you use axios you only have to add the endpoint to request without the /api/v1

Usage example:

```js
import { generateAxiosInstance } from '@helpers/axios_provider.js';
const axios = generateAxiosInstance('/api/v1')

axios.get('/users')
```

> **Note**
> The Journey Manager already has an axios instance added at the project level, so it is not necessary to create another axios instance, just use the injection of "$axios"
> ```js
> export default {
>   inject: ['$axios'],
> 
>   mounted() {
>     this.$axios.get('/users')
>   }
> }
> ```

---

## Promo watcher
The promo watcher is a mixin dedicated to managing the promotion change, taking into account that the view to which it is imported has a server table, in addition to providing the option of taking advantage of the event with "insidePromoChange(promo)" and an "afterMounted()"

Usage example:

```js
import PromoWatcher from '@helpers/promo_watcher.js';

export default: {
  mixins: [PromoWatcher],
          
  methods: {
    afterMounted() {
      // do something here..
    },
    insidePromoChange(promo){
      // Add action when the user change the selected promo, this
      // run after the refresh() from server table
    }
  }
}
```

---

## Date watcher
The date watcher is a mixin that monitors the date variable, this helps in cases where we import a DatePicker to make date filters in the server table, so this mixin monitors automatically.

Usage example:

```js
import DateWatcher from '@helpers/date_watcher.js';

export default: {
  mixins: [DateWatcher],
}
```

## Generate component
The generate component is in charge of rendering a vue component from an entrypoint, it can be passed the parameters to indicate the injections, components, packages, etc.

Usage example:

```js
import App from '@views/login/Index.vue';
import { generateApplication } from '@helpers/generate_component.js';
import { autoAnimatePlugin } from "@formkit/auto-animate/vue"
import VueSweetalert2 from "vue-sweetalert2";
import 'sweetalert2/dist/sweetalert2.min.css';

generateApplication(
  App, // Main component
  "#login-app", // Html identifier to mount
  {
    // Configuration
    packages: [autoAnimatePlugin, VueSweetalert2],
    injections: [],
    props: {},
    components: [],
    globalEventsProvider: null
  }
)
```

---

## Download action
The download action mixin allows you to manipulate the action of downloading a report in a simple way, which requires you to implement the html that will make the report and, if necessary, what object it will generate (this has the name of the view by default).

Usage example:

```vue
<template>
  <!--download comes from DownloadAction mixin and make the download action (you can pass the object type like: download('contacts')) and that wil generate the following url: /api/v1/reports/:promo/contacts by default: /api/v1/reports/:promo/${currentViewName}-->
  <a href="#" class="btn-link" @click.prevent="download()">
    <!-- downloadIsLoading comes from DownloadAction mixin and controls the loading status for download button-->
    <div v-if="downloadIsLoading" class="spinner-border spinner-border-sm"></div>

    Generar reporte
  </a>
</template>

<script>
import DownloadAction from "@helpers/download_action";

export default {
  mixins: [DownloadAction]
}
</script>
```

---

## Manage loading status
This mixin allows you to manipulate the loading states of the actions of a server table or of any other component, what it does is maintain an array of states where it indicates if it is loading or if it resulted in an error, so it provides methods that add, remove , validate the status of any action.

Usage example:

```vue

<template>
  <!-- Provides a variable called "actions Status" which stores all statuses -->
  <div v-for="status in actionsStatus">
    id: {{ status.id }}
    loading: {{ status.loading }}
    error: {{ status.error }}
  </div>
</template>

<script>
import ManageLoadingStatus from "@helpers/manage_loading_status.js";

export default {
  mixins: [ManageLoadingStatus],
  
  mounted() {
    // Returns the index for the status with id '1'
    const index = this.getStatusIndex(1)

    // Returns the status with id '1'
    const status = this.getStatus(1)

    // Remove the status with id '1'
    this.removeStatus(1)

    // Add new status with the following properties:
    // { id: 1, loading: true, error: false }
    let loading = true;
    let error = false;
    this.pushStatus(1, loading, error)

    // Get the last status index
    this.getStatusLastIndex()

    // Remove the last status item
    this.removeLastItem()

    // Set error as true for the last item
    this.setErrorToLastItem()

    // Verify if the status with id '1' is loading
    // when the status has error, the method remove this status to start new one
    this.isInvalidRequest(1)
  }
}
</script>
```

---

## General helpers
We added a general mixin where those functions of general use can be added

Usage example:

```js
import {
  capitalize,
  updateURLParameter,
  getUrlParameter,
  setTooltips,
  filterHeadersByPermissions,
  getHeadersForTable,
  getStringAcronym,
} from '@helpers/helpers.js'

// Returns "'Hello world!'"
capitalize("hello world!")

// Returns the current url and the new/updated parameter (includes anchors and other existing parameters)
updateURLParameter(window.location.href, "promotion", "promotion-2023")

// Returns the requested url parameter
getUrlParameter('promotion')

// Set all tooltips identified in the component
setTooltips()

// Filter all headers by permissions, this value usually comes from the config file 
filterHeadersByPermissions(headers)

// Filters headers by permissions and map that headers for server table component
getHeadersForTable(headers)

// Returns the first letters for every word
getStringAcronym('Fabian Garcia') // return 'FG'
```

---

## Config JS
The Journey Manager is based on being able to configure most things, some will address the CXF instance, things like users, promotions, however which components come out with n permissions, which columns will appear in the server table or even which segments are available for tables, all this is defined by the configuration file, in this case the config.js

Therefore, any change to this file can be considered delicate and everything should have a definition of how to structure the configuration for n things.

From the outset, the object will have a default state, it will have an object for each view, for example:
```js
{
  default: {
    participants: {
      //config here...
    },

    participant: {
      //config here...
    },

    awards: {
      //config here...
    },
  }
}
```

In each of these views you can add variables to add/hide things, for example:

From the outset, the object will have a default state, it will have an object for each view, for example:
```js
{
  default: {
    participants: {
      showAnalytics: true,
      showSearch: true,
      showDateFilter: true,
      canGenerateReport: true,
    },

    participant: {
      canEdit: true,
      showConversation: false,
    },

  }
}
```

But in the case of wanting to add the configuration of a server table, it must have the standardization of the data structure for the table, for example:
```js
{
  default: {
    participants: {
      headers: [{
        label: 'Nombre completo',
        key: 'name',
      }, {
        label: 'Correo electrónico',
        key: 'email',
        vIf: () => ( verifyPermission('view|edit', 'config') ) // Yeah, you can verify permissions to show this column
      }]
    },
    
    // When te table has filters and every filter change the columns to show, use
    // the following structure:
    participant: {
      filters: [{
        segment: 23, // Segment id or slug
        title: 'Registros completos', // Filter title
        default: true, // Is the filter selected by default?
        // And headers
        headers: [{
          label: 'Registro',
          key: (row, that) => (that.formatter.format(new Date(row.created_at)) + 'hrs')
        }]
      }]
    },

  }
}
```

The server table currently has the following types of fields:

```js
// Default type, only render a text, can be string or function
// the function has 2 parameters, row and the component context
// the key value always can be string or function
[{
  label: 'Nombre completo',
  key: 'name',
}, {
  label: 'Correo electrónico',
  key: (row) => ( row.email ),
}, {
  label: 'Craeted at',
  key: (row, that) => (
    //  that is the context for the row component, usually gives the way to use formatters
    // special methods, etc.
    that.formatter.format(new Date(row.created_at)) + 'hrs'
  ),
}]

// Link type, render router link tag
{
  label: 'Nombre',
  key: 'given_name',
  type: 'link',
  link: '/app/participantes/:rowId' // :rowId will be replaced by the id
}

// Actions type, render dropdown with every action available
// onClick method always has the row and that parameters
{
  label: 'Acciones',
  type: 'actions',
  actions: [{
    label: 'Editar datos',
    onClick: () => {}
  },{
    label: 'Descalificar',
    onClick: (row, that) => {
      that.makeAxiosRequest('/contacts/disqualify', row, 'Se ha descalificado el participante {{contact}}')
    }
  },{
    label: 'Bloquear',
    onClick: (row, that) => {
      that.makeAxiosRequest('/contacts/ban', row, 'Se ha bloqueado el participante {{contact}}')
    }
  }]
}

// Asset type, render a img tag
{
  label: 'Archivo',
  type: 'asset',
  src: (row) => ( row?.object?.file?.public_path ),
  alt: (row) => ( row?.object?.file?.alt ),
}

// Status type, render component that print the status for the record, like
// published, invalid, etc.
{
  label: 'Estatus',
  type: 'status',
  key: (row) => (row?.object?.status || 'Sin revisar'),
  class: (row) => (row?.object?.status?.toLowerCase() || 'pending'), // Add clases to the component
  onClick: (row, that) => { that.$emit('openModal', row) }, // When the user click the pencil component, this callback will be fired
}

// Accordion type, render an accordion, this have the short and long value
// the long value prints down the row and has all the table width
// Long value and short value can be string or function
// The empty state shows when the record does not meet the requirements
// isEmpty indicates that requirements to show the accordion or empty state

{
  label: 'Permisos',
  type: 'accordion',
  short_value: (row) => (row.permissions.map(p => p.title).join(", ")),
  long_value: (row) => (
    row.permissions.map((p, index) =>
            (((index % 3 === 1 && index > 1) || index === 0) ? "<div>" : '')
            + p.title + "<ul class='m-0'>" + ( p?.items?.map(i => "<li>" + (i?.title) + "</li>").join('')) + "</ul>"
            + ((index % 3 === 0 && index > 1)? "</div>" : '')
    ).join('')
  ),
  emptyState: 'Sin permisos',
  isEmpty: (row) => (row.permissions?.length < 1)
}

// Dynamic type

{
  label: 'Nombre',
  key: 'given_name',
  type: () => ( 
    verifyPermission('view|edit', 'participant') ? 'link' : 'text'
  ),
  link: '/app/participantes/:rowId'
}
```

You can add default filters for the table, for example:

```js
participantes: {
  table: {
    pageSize: 25
  },
},
```

If you want to add tabs for some view, we recommend to add the following structure:

```js
{
  participante: {
    tabs: [{
      label: 'Participaciones',
      key: 'participations_count',  // Is the key where the counter is stored, this need to be in the record data
      api: '/participations',       // this is the api will be used in the server table when the tab is selected
      headers: [                    // Headers for the table when the tab is selected
        // Your headers here...
      ]
    }, {
      label: 'Votos recibidos',
      key: 'given_votes',
      api: '/votes',
      headers: [
        // Your headers here...
      ],
    }]
  }
}
```

When you want to add permissions for something like tabs, columns and other values, we recommend
to use the permissions component, like this:

```js
{
  // your config here...
  vIf: () => ( verifyPermission('required permissions here', 'your module here') )
}
```

or


```js
{
  // your config here...
  permissions: {
    I: 'required permissions here',
    a: 'your module here'
  }
}
```
And use the "Can" component inside the target component
