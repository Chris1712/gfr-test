<!--
  Component representing all the details of a scroll
-->
<script setup lang="ts">
defineProps<{
  name: string
}>()
</script>

<template>
  <div class="scroll-detail">
    <h1>{{ name }}</h1>
    <p>
      This is a scroll detail component. It is used to display a detail view of a scroll item.
    </p>
  </div>
</template>