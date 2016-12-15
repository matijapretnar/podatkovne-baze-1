% rebase('osnova.tpl')
<h1>Delitelji števila {{n}} so:</h1>

<ul>
    %for d in delitelji:
    <li>{{d}}</li>
    %end
</ul>
