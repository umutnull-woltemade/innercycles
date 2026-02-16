<script setup lang="ts">
interface Props {
  size?: number;
  class?: string;
}

const props = withDefaults(defineProps<Props>(), {
  size: 48,
  class: ''
});
</script>

<template>
  <NuxtImg
    src="/brand/app-logo.svg"
    alt="InnerCycles"
    :width="props.size"
    :height="props.size"
    :class="props.class"
    :style="{
      width: `${props.size}px`,
      height: `${props.size}px`,
      objectFit: 'contain'
    }"
  />
</template>