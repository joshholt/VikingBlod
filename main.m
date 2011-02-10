//
//  main.m
//  VikingBlood
//
//  Created by Joshua Holt on 2/3/11.
//  Copyright Eloqua Ltd. 2011. All rights reserved.
//

#import <MacRuby/MacRuby.h>
#import <BWToolkitFramework/BWToolkitFramework.h>

int main(int argc, char *argv[])
{
    return macruby_main("rb_main.rb", argc, argv);
}
