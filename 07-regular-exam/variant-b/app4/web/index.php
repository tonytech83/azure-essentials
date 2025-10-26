<!doctype html>

<html lang="en">
    <head>
        <meta charset="utf-8" />
        <meta name="viewport" content="width=device-width" />
        <title>Top 10 cities in Bulgaria</title>
        <link rel="stylesheet" type="text/css" href="/index.css" media="screen">
    </head>
    <body>
        <div class="container">
<?php
    $cities = [["Sofia", 1307376], 
                ["Plovdiv", 341625], 
                ["Varna", 334466], 
                ["Burgas", 203017], 
                ["Stara Zagora", 148443], 
                ["Ruse", 145765], 
                ["Pleven", 99628], 
                ["Sliven", 87895],
                ["Dobrich", 86292], 
                ["Veliko Tarnovo", 73508]
            ];
    
    $cityid = random_int(0, 9);

    print "<div class=\"item\" id=\"item-city\">".$cities[$cityid][0]."</div>\n";
    print "<div class=\"item\" id=\"item-population\">".$cities[$cityid][1]."</div>\n";
    print "<div class=\"item\" id=\"item-note\">Refresh for more ...</div>\n";
    print "<br /><br /><br />\n";
    print "<div class=\"item\" id=\"item-footer\">Processed by <b>".gethostname()."</b> on ".date('Y-m-d-H-i-s')."</div>\n";
?>
        </div>
    </body>
</html>