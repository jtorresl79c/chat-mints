// Store
import { dynamicFormStore } from "../stores/store";
import { mapStores, mapActions } from 'pinia'

export default {
  inject: ['$contact'],
  computed: {
    ...mapStores(dynamicFormStore),
  },
  methods: {
    ...mapActions(dynamicFormStore, ['updateAnswer']),
    initializeContact() {
      if (this.$contact) {
        Object.keys(this.$contact).forEach(key => {
          this.updateAnswer({key, value: this.$contact[key]});
        })
      }
    }
  }
}