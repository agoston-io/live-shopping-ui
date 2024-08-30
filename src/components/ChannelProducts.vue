<template>
  <div class="row g-0">
    <div class="col fw-bold">
      Other products
    </div>
  </div>
  <div class="row g-0" v-if="$apollo.queries.products.loading">Loading...</div>
  <div class="row g-0" v-else>
    <div class="col-12 col-lg-3 p-1" v-for="item in products.nodes" :key="item.id">
      <div class="card bg-white text-secondary p-0 border-0">
        <div class="row g-0">
          <div class="col-5 p-0">
            <a class="link-secondary" href="#">
              <img src="https://picsum.photos/100/100" class="img-fluid rounded-start" alt="..." />
            </a>
          </div>
          <div class="col-6 p-0">
            <div class="card-body p-0">
              <p class="mt-4 mb-0">
                <a class="link-secondary" href="#">{{ item.name }}</a>
              </p>
              <h5 class="card-title mt-3 mb-0 pb-0">{{ item.price }}.–</h5>
            </div>
          </div>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
// Project libraries
import isMobile from "../isMobile.js";
// GraphQL
import PRODUCTS from "../graphql/products.gql";

export default {
  name: "channel-products",
  props: ["channelId"],
  data() {
    return {
      products: {},
    };
  },
  apollo: {
    products: {
      query: PRODUCTS,
      variables() {
        return {
          channelId: parseInt(this.channelId),
          first: isMobile() ? 1 : 4,
        };
      },
    },
  },
};
</script>