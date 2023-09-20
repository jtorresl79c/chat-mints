<template>
  <CaliServerTable
    ref="serverTable"
    :options="{
      api: `/contacts`,
      search: false,
      headers: ['ID', 'Nombre', 'Email'],
    }">

    <template #custom_filters>
      <div class="d-flex align-items-center mx-3">
        Filtro:
        <select class="form-control mx-3">
          <option> Todos los contactos</option>
        </select>
      </div>
    </template>

    <template v-slot:row="{ row }">
      <td class="ps-4 data-column text-sm font-weight-normal"> {{ row?.id }} </td>
      <td class="ps-4 data-column text-sm font-weight-normal"> {{ row?.full_name }} </td>
      <td class="ps-4 data-column text-sm font-weight-normal"> {{ row?.email }} </td>
    </template>
  </CaliServerTable>

</template>

<script>
import CaliServerTable from "@mints-components/cali-server-table/App.vue";

export default {
  components: { CaliServerTable },
}
</script>