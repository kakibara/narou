# -*- coding: UTF-8 -*-
#
# Copyright 2013 whiteleaf. All rights reserved.
#

require "fileutils"
require_relative "helper"
require_relative "localsetting"
require_relative "globalsetting"

module Narou
  LOCAL_SETTING_DIR = ".narou"
  GLOBAL_SETTING_DIR = ".narou_g"
  AOZORAEPUB3_JAR_NAME = "AozoraEpub3.jar"
  AOZORAEPUB3_DIR = "./AozoraEpub3"
  PRESET_DIR = "./preset"

  @@root_dir = nil
  @@local_setting_dir = nil
  @@global_setting_dir = nil
  @@aozora_path = nil
  @@preset_dir = nil

  def self.get_root_dir
    return @@root_dir if @@root_dir
    path = File.expand_path(File.dirname("."))
    drive_letter = ""
    if Helper.os_windows?
      path.gsub!(/^[a-z]:/i, "")
      drive_letter = $&
    end
    while path != ""
      if File.directory?("#{path}/#{LOCAL_SETTING_DIR}")
        @@root_dir = drive_letter + path
        break
      end
      path.gsub!(%r!/[^/]*$!, "")
    end
    @@root_dir
  end

  def self.get_local_setting_dir
    return @@local_setting_dir if @@local_setting_dir
    root_dir = get_root_dir
    if root_dir
      @@local_setting_dir = File.join(root_dir, LOCAL_SETTING_DIR)
    end
    @@local_setting_dir
  end

  def self.get_global_setting_dir
    return @@global_setting_dir if @@global_setting_dir
    @@global_setting_dir = File.expand_path(File.join("~", GLOBAL_SETTING_DIR))
    unless File.exists?(@@global_setting_dir)
      FileUtils.mkdir(@@global_setting_dir)
    end
    @@global_setting_dir
  end

  def self.get_script_dir
    File.expand_path(File.dirname($0))
  end

  def self.already_init?
    !!get_root_dir
  end

  def self.init
    return nil if already_init?
    FileUtils.mkdir(LOCAL_SETTING_DIR)
    puts LOCAL_SETTING_DIR + "/ を作成しました"
    Database.init
  end

  def self.alias_to_id(target)
    aliases = LocalSetting.get["alias"]
    if aliases[target]
      return aliases[target]
    end
    target
  end

  def self.novel_frozen?(target)
    id = Downloader.get_id_by_database(target) or return false
    LocalSetting.get["freeze"].include?(id)
  end

  def self.create_aozoraepub3_jar_path(*paths)
    File.expand_path(File.join(*paths, AOZORAEPUB3_JAR_NAME))
  end

  def self.aozoraepub3_directory?(path)
    File.exists?(create_aozoraepub3_jar_path(path))
  end

  def self.get_preset_dir
    return "C:/Users/sasa/Documents/GitHub/narou/preset"
    return @@preset_dir if @@preset_dir
    @@preset_dir = File.expand_path(File.join(get_script_dir, PRESET_DIR))
    @@preset_dir
  end

  #
  # AozoraEpub3 の実行ファイル(.jar)のフルパス取得
  # 検索順序
  # 1. グローバルセッティング (global_setting aozoraepub3path)
  # 2. 小説保存ディレクトリ(Narou.get_root_dir) 直下の AozoraEpub3
  # 3. スクリプト保存ディレクトリ(Narou.get_script_dir) 直下の AozoraEpub3
  #
  def self.get_aozoraepub3_path
    return @@aozora_path if @@aozora_path
    global_setting_aozora_path = GlobalSetting.get["global_setting"]["aozoraepub3path"]
    if global_setting_aozora_path
      aozora_path = create_aozoraepub3_jar_path(global_setting_aozora_path)
      if File.exists?(aozora_path)
        @@aozora_path = aozora_path
        return aozora_path
      end
    end
    [Narou.get_root_dir, Narou.get_script_dir].each do |dir|
      aozora_path = create_aozoraepub3_jar_path(dir, AOZORAEPUB3_DIR)
      if File.exists?(aozora_path)
        @@aozora_path = aozora_path
        return aozora_path
      end
    end
    nil
  end
end
