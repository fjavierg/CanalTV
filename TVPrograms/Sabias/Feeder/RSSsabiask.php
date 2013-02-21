<?
/**
 * Sabias Que RSS generator
 *
 * Genrates RSS feed file from local contents
 *
 * PHP version 5
 *
 * LICENSE: TBC
 *
 * @category   Contents
 * @package    Contents.SabiasK
 * @author     Javier Gómez
 * @version    SVN: $Id$
 * @link       
 * @see        
 */

include("feedcreator.class.php");


$Contents_dir = '..\..\..\Contents\\';
$RSS_output = 'sabias.xml';

$rss = new UniversalFeedCreator();
$rss->useCached();
$rss->title = "Sabias Qué";
$rss->description = "Curiosidades";
$rss->link = "http://www.jagova65.com";

// get your news items from somewhere, e.g. your database:
$lines = file('sabiask.txt');
$len=count($lines);


for ($i = 1; $i <= 4; $i++) {

    $item = new FeedItem();
    $item->title = 	$lines[rand(1,$len)];
    $item->link = "http:/jagova65.com";
    $item->description = "bla-bla-bla";
    $item->date = time();
    $item->source = "http://www.jagova65.com";
    $item->author = "Jagova65";
    
    $rss->addItem($item);
}

$rss->saveFeed("RSS2.0", "sabias.xml");
?> 
