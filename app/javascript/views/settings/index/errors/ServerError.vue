<template>
  <main class="main-content mt-0 ps">
    <div>
      <section class="min-vh-100 d-flex align-items-center">
        <div class="container">
          <div class="row mt-lg-0 mt-8">
            <div class="col-lg-5 my-auto">
              <h1
                  class="display-1 text-bolder text-gradient text-warning fadeIn1 fadeInBottom mt-5"
              >
                Error 500
              </h1>
              <h2 class="fadeIn3 fadeInBottom opacity-8">
                Something went wrong
              </h2>
              <p class="lead opacity-6 fadeIn2 fadeInBottom">
                We suggest you to go to the homepage while we solve this issue.
              </p>

            </div>
            <div class="col-lg-7 my-auto">
              <img
                  class="w-100 fadeIn1 fadeInBottom"
                  src="https://comeximplprod-16905.kxcdn.com/public-assets/error-500"
                  alt="500-error"
              />
            </div>
          </div>
        </div>
      </section>
    </div>
    <div class="ps__rail-x" style="left: 0px; bottom: 0px">
      <div class="ps__thumb-x" tabindex="0" style="left: 0px; width: 0px"></div>
    </div>
    <div class="ps__rail-y" style="top: 0px; right: 0px">
      <div class="ps__thumb-y" tabindex="0" style="top: 0px; height: 0px"></div>
    </div>
  </main>
</template>
<script>
export default {
  name: "ServerError"
};
</script>
