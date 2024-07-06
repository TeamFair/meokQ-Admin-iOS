//
//  DependencyInjector.swift
//  MatQ_Admin
//
//  Created by Lee Jinhee on 3/6/24.
//

import Swinject

/// DI 대상 등록
public protocol DependencyAssemblable {
    func assemble(_ assemblyList: [Assembly])
    func register<T>(_ serviceType: T.Type, _ object: T)
}

/// DI 등록한 서비스 사용
public protocol DependencyResolvable {
    func resolve<T>(_ serviceType: T.Type) -> T
    func resolve<T, Arg>(_ serviceType: T.Type, argument: Arg) -> T
    func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, argument1: Arg1, argument2: Arg2) -> T
}

/// Injector 타입은 DependencyAssemblable, DependencyResolvable 프로토콜을 따름
public typealias Injector = DependencyAssemblable & DependencyResolvable

/// 의존성 주입을 담당
public final class DependencyInjector: Injector {
    private let container: Container
    
    public init(container: Container) {
        self.container = container
    }
    
    public func assemble(_ assemblyList: [Assembly]) {
        assemblyList.forEach {
            $0.assemble(container: container)
        }
    }
    
    public func register<T>(_ serviceType: T.Type, _ object: T) {
        container.register(serviceType) { _ in object }
    }
    
    public func resolve<T>(_ serviceType: T.Type) -> T {
        container.resolve(serviceType)!
    }
    
    public func resolve<T, Arg>(_ serviceType: T.Type, argument: Arg) -> T {
        container.resolve(serviceType, argument: argument)!
    }  
    
    public func resolve<T, Arg1, Arg2>(_ serviceType: T.Type, argument1: Arg1, argument2: Arg2) -> T {
        container.resolve(serviceType, arguments: argument1, argument2)!
    }
}
