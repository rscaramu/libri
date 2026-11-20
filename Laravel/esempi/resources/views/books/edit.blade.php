<x-layout><form method="POST"
      action="{{ route('books.update', $book) }}">
    @csrf
    @method('PUT')

    <x-forms.input name="title" label="Titolo"
                   :value="$book->title" required />
    <x-forms.input name="year" label="Anno" type="number"
                   :value="$book->year" min="1450" />

    <x-button type="submit">Salva</x-button>
</form>
<x-alert type="success" title="Fatto" id="esito">
    Il libro è stato salvato.
</x-alert><x-loan-badge :loan="$loan" /><x-badge :color="$book->available ? 'verde' : 'rosso'">D</x-badge></x-layout>
