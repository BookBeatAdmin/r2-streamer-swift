//
//  ContainerCbzDirectory.swift
//  r2-streamer-swift
//
//  Created by Alexandre Camilleri on 4/3/17.
//
//  Copyright 2018 Readium Foundation. All rights reserved.
//  Use of this source code is governed by a BSD-style license which is detailed
//  in the LICENSE file present in the project repository where this source code is maintained.
//

import R2Shared

extension ContainerCbzDirectory: Loggable {}

/// Container for expanded CBZ publications.
public class ContainerCbzDirectory: CbzContainer, DirectoryContainer {
    public var attribute: [FileAttributeKey : Any]?
    
    /// See `RootFile`.
    public var rootFile: RootFile
    public var drm: Drm?

    /// Public failable initializer for the EpubDirectoryContainer class.
    ///
    /// - Parameter dirPath: The root directory path.
    public init?(directory path: String) {
        guard FileManager.default.fileExists(atPath: path) else {
            ContainerCbzDirectory.log(level: .error, "File not found.")
            return nil
        }
        rootFile = RootFile.init(rootPath: path, mimetype: CbzConstant.mimetype)
    }

    /// Returns an array of the containers contained files names.
    ///
    /// - Returns: The array of the container file's names.
    public func getFilesList() -> [String] {
        guard let path =  rootFile.rootPath.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed),
            let url = URL(string: path) else
        {
            return []
        }
        guard let list = try? FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: []) else {
            return []
        }

        return list.map({ $0.path.lastPathComponent })
    }
}

