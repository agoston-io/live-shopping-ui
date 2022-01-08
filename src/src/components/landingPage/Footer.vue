<template>
  <footer class="footer mt-auto py-3 bg-dark">
    <div class="container text-center">
      <span class="text-muted me-2">© 2021 Live shopping UI | share</span>
      <span class="text-muted"><SocialNetwork /></span>
    </div>
  </footer>
</template>

<script>
import SocialNetwork from "./SocialNetwork.vue";
export default {
  name: "Menu",
  components: {
    SocialNetwork,
  },
};
</script>
