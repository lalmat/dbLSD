-- phpMyAdmin SQL Dump
-- version 4.0.10deb1
-- http://www.phpmyadmin.net
--
-- Client: localhost
-- Généré le: Dim 18 Octobre 2015 à 19:13
-- Version du serveur: 5.5.44-0ubuntu0.14.04.1
-- Version de PHP: 5.6.14-1+deb.sury.org~trusty+1

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données: `test`
--

-- --------------------------------------------------------

--
-- Structure de la table `tst_client`
--

CREATE TABLE IF NOT EXISTS `tst_client` (
  `tsc_id` int(11) NOT NULL,
  `tsc_name` varchar(255) NOT NULL,
  PRIMARY KEY (`tsc_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `tst_data`
--

CREATE TABLE IF NOT EXISTS `tst_data` (
  `tsd_id` int(11) NOT NULL,
  `tsd_tsc_id` int(11) NOT NULL,
  `tsd_datetime` datetime NOT NULL,
  `tsd_data` text NOT NULL,
  PRIMARY KEY (`tsd_id`),
  KEY `tsd_tsc_id` (`tsd_tsc_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
