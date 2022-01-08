<template>
  <Menu />
  <main class="container-fluid mt-3">
    <Claim />
  </main>
  <Footer />
</template>

<script>
import Menu from "./Menu.vue";
import Claim from "./Claim.vue";
import Footer from "./Footer.vue";

export default {
  components: {
    Menu,
    Claim,
    Footer,
  },
};
</script>

