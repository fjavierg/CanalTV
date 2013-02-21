<?php
/**
 * RSS grabber
 *
 * This script fetchs last news from 'El Pais' main RSS feed and 'Yahoo' Weather forecast website
 * Info grabed is stored in local files for later use.
 *
 * PHP version 5
 *
 * LICENSE: TBC
 *
 * @category   Contents
 * @package    Contents.RSSreader
 * @author     Javier Gómez
 * @version    SVN: $Id$
 * @link       
 * @see        
 */

$Contents_dir = '..\..\..\Contents\\';

$RSS_url = 'http://ep01.epimg.net/rss/elpais/portada.xml';
$RSS_output = $Contents_dir . 'elpais.txt';

$Yahoo_url = 'http://xml.weather.yahoo.com/forecastrss?p=SPXX0015&u=c';
$Yahoo_output = $Contents_dir . 'yahoo_bcn.txt';


$ch = curl_init();
/**
 * Curl to RSS url
 *       
 */

curl_setopt($ch, CURLOPT_URL,$RSS_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);

$result=curl_exec ($ch);

$fp = fopen($RSS_output, 'w');
fwrite($fp, $result);
fclose($fp);

/**
 * Curl to Yahoo
 *       
 */

curl_setopt($ch, CURLOPT_URL,$Yahoo_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
$result=curl_exec ($ch);
$fp = fopen($Yahoo_output, 'w');
fwrite($fp, $result);
fclose($fp);


curl_close ($ch);

?>
