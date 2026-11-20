<section class="card">
    @isset($header)
        <header class="card-header">{{ $header }}</header>
    @endisset

    <div class="card-body">{{ $slot }}</div>

    @isset($footer)
        <footer class="card-footer">{{ $footer }}</footer>
    @endisset
</section>
