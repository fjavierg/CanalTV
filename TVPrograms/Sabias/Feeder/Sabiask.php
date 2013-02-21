<?php
/**
 * Sabias Que grabber
 *
 * This script fetchs info from 'Wikipedia' splits it into chunks and store them
 * in local files for later use.
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

$Contents_dir = '..\..\..\Contents\\';

$RSS_url = 'http://es.wikipedia.org/wiki/Plantilla:Sab%C3%ADas_que_(enero_2006)';
  
 
$ch = curl_init();
/**
 * Curl to RSS url
 *       
 */
curl_setopt($ch, CURLOPT_URL,$RSS_url);
curl_setopt($ch, CURLOPT_RETURNTRANSFER,1);
$page=curl_exec ($ch);

/**
 * Explode contents <li> into different lines
 *       
 */
$parts = explode("<li>",$page);

foreach ($parts as $part) {
	$line=strip_tags($part);
	if (strlen($line)<200 and strlen($line)>10) {
		echo $line;
	}
}

?>