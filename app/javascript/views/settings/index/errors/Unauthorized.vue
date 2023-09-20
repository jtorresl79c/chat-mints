<template>
  <section class="my-10">
    <div class="container">
      <div class="row">
        <div class="col-lg-6 my-auto">
          <h1 class="display-1 text-bolder text-gradient text-danger">
            Error 401
          </h1>
          <h2>Permisos insuficientes</h2>
          <p class="lead">
            No tiene suficientes permisos para ingresar a la configuración, comuníquese con el administrador para obtener asistencia.
          </p>

        </div>
        <div class="col-lg-6 my-auto position-relative">
          <img
              class="w-100 position-relative"
              src="https://comeximplprod-16905.kxcdn.com/public-assets/unauthorized"
              alt="404-error"
          />
        </div>
      </div>
    </div>
  </section>
</template>

<script>
export default {
  name: "Unauthorized",
};
</script>
