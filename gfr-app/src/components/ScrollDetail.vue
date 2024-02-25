<!--
  Component presenting all the details of a scroll
  Input is the index of the scroll
-->
<script setup lang="ts">
import ScrollImage from "@/components/ScrollImage.vue";
import ScrollUtils, { type Scroll, type ScrollType } from "@/services/ScrollUtils";


const props = defineProps<{
  index: number
}>()

const scroll: Scroll = ScrollUtils.getScrolls()[props.index];
const color = `var(--color-scroll-${scroll.type})`;

</script>

<template>
  <h1>{{ scroll.name }}</h1>
  <p class="type">{{ scroll.type }}</p>
  <scroll-image :index="props.index" />
  <p>{{ scroll.desc }}</p>
  <p v-if="scroll.descEnhanced"><br><em>Enhanced:</em> {{ scroll.descEnhanced }}</p>
</template>

<style scoped>

  h1, p {
    text-align: center;
  }

  p.type::first-letter {
    text-transform: uppercase;
  }

  p.type {
    color: v-bind('color')
  }


  em {
    font-weight: bold;
    color: var(--color-enhanced);
  }

</style>