import { computed, reactive } from 'vue'
import useVuelidate from "@vuelidate/core";
import { email, required, minLength, maxLength } from "@vuelidate/validators";
// export { required, email, minLength, maxLength } from '@vuelidate/validators'

export function validName(name) {
    let validNamePattern = new RegExp("^[a-zA-Z]+(?:[-'\\s][a-zA-Z]+)*$");
    if (validNamePattern.test(name)) {
        return true;
    }
    return false
}

export function attachValidations(field) {
    let validation = {}

    if (field.required) {
        validation = {...validation, required }
    }

    if ((field.validations || []).includes('email')) {
        validation = {...validation, email }
    }

    if ((field.validations || []).includes('max:')) {
        let lengthMax = field.validations.find(x => x.includes('max:')).split(':')
        validation = {...validation, ...maxLength(lengthMax[lengthMax.length - 1]) }
    }

    if ((field.validations || []).includes('min:')) {
        let lengthMin = field.validations.find(x => x.includes('min:')).split(':')
        validation = {...validation, ...minLength(lengthMin[lengthMin.length - 1]) }

    }

    if (field.validName) {
        validation = {...validation,
            ... {
                name_validation: {
                    $validator: validName,
                    $message: 'Invalid Name. Valid name only contain letters, dashes (-) and spaces'
                }
            }
        }

    }

    return validation
}

export const generateValidatorInstance = (form) => {
    const fields = form && form.config_json ? form.config_json.fields : [];

    let validations = {}
    let formState = {}
    fields.forEach(field => {
        validations[field.slug] = attachValidations(field)
        formState[field.slug] = null
    });

    const rules = computed(() => ({
        formFilled: validations,
    }))

    const state = reactive({
        formFilled: formState
    })

    return useVuelidate(rules, state);
};