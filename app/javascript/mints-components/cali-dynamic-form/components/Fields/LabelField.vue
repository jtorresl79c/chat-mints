<template>
  <label class="contact-step-form__label text-left ">
    {{ help }}
  </label>
</template>
<script>
  export default {
    inject: ['$contact'],
    props: {
      field: {
        type: Object
      }
    },
    computed: {
      help() {
        if (this.$contact && Boolean(this.field?.extra_parameters?.autofilllabel)) {
          let query = this.field.extra_parameters.autofilllabel
          let regexp = new RegExp('{{\\w+[\\.\\w]?\\w+}}', "g");
          let keys = regexp.exec(query);

          if (keys?.length > 0) {
            keys.forEach(key => {
              let attributes = key.replace('{{', '').replace('}}', '')
              attributes = attributes.split('.');

              if (attributes?.length > 1) {
                query = query.replaceAll(key, this.getObjectValue(attributes))
              } else {
                query = query.replaceAll(key, this.$contact[attributes[0]])
              }
            })
          }

          return query
        }

        return this.field.help
      }
    },

    methods: {
      getObjectValue(keys) {
        let helper = JSON.parse(JSON.stringify(this.$contact))

        keys.forEach(key => {
          if (helper && helper[key]) {
            helper = helper[key]
          } else {
            helper = ''
          }
        });

        return helper
      }
    }
  }
</script>