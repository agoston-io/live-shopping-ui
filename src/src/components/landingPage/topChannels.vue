<template>
  <div class="row mt-4">
    <div class="col-12">Top Creators</div>
    <div class="col-12"><hr class="mt-0 mb-0" /></div>
    <div class="col-12" v-if="$apollo.queries.topChannels.loading">
      Loading...
    </div>
    <div class="col-12" v-else>
      <div
        class="col-12 mt-2 fs-6 text-truncate"
        v-for="item in topChannels.nodes"
        :key="item.id"
      >
        <div class="d-flex justify-content-between">
          <a v-bind:href="'?channel=' + item.id"> {{ item.name }} </a><br />
          <span class="text-muted">
            <font-awesome-icon class="me-1" :icon="['fas', 'thumbs-up']" />
            {{ item.broadcasts.groupedAggregates[0].sum.liked }}
          </span>
        </div>
        <span class="text-muted"> By {{ item.user.username }} </span>
      </div>
    </div>
  </div>
</template>

<script>
// GraphQL
import TOP_CHANNELS from "../../graphql/topChannels.gql";

export default {
  name: "top-channels",
  data() {
    return {
      topChannels: {},
    };
  },
  apollo: {
    topChannels: {
      query: TOP_CHANNELS,
    },
  },
};
</script>
