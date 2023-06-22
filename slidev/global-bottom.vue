<template>
  <footer v-if="$slidev.nav.currentLayout !== 'intro'">
    <div
      class="bg-purple-900 text-purple-50 dark:(bg-purple-900 text-purple-50) flex absolute w-full bottom-0 left-0 py-0.5 px-4 text-sm"
      style="z-index: 9999"
    >
      <div class="w-1/2 text-left">
        {{ $slidev.nav.currentPage }} /
        {{ $slidev.nav.total }}
      </div>
      <div class="w-1/2 flex justify-end">
        <div class="flex justify-center items-center ml-4">
          <span class="flex justify-center item-center">
            <carbon:logo-github />
          </span>
          <a href="https://github.com/tokku5552/liff-terraform-sample"
            ><span class="ml-0.5">tokku5552/liff-terraform-sample</span></a
          >
        </div>

        <div class="flex justify-center items-center ml-4">
          <span class="flex justify-center item-center">
            <carbon:logo-twitter />
          </span>
          <a href="https://twitter.com/tokkuu">
            <span class="ml-0.5">tokkuu</span>
          </a>
        </div>

        <div class="flex justify-center items-center ml-4">
          <span class="flex justify-center item-center">
            <carbon:link />
          </span>
          <a href="https://tokku5552.github.io/liff-terraform-sample">
            <span class="ml-0.5">pages</span>
          </a>
        </div>
      </div>
    </div>
  </footer>
</template>
