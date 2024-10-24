// Author           : Marcin Bajkowski ( s193696@student.pg.edu.pl )
// Created On       : 11.06.2023
// Last Modified By : Marcin Bajkowski ( s193696@student.pg.edu.pl )
// Last Modified On : 12.06.2021
// Version          : v1.1
// Description      : Simple implementation of ls command in C
// Command          : gcc -o ls ./OperatingSystems/ls.c 

#include <stdio.h> //printf, scanf
#include <stdlib.h> //malloc, free
#include <string.h> //strcpy, strlen
#include <dirent.h> //opendir, readdir, closedir
#include <sys/stat.h> //stat, information about file
#include <pwd.h> //getpwuid, passwd, information about user
#include <grp.h> //getgrgid, group, information about group
#include <time.h> //strftime, localtime
#include <locale.h> //setlocale

const int PATH_MAX = 4096; 

char* getPermissions(mode_t mode) { //returns char array / string with permissions
    char *permissions = (char *)malloc(11 * sizeof(char));
    permissions[0] = (S_ISDIR(mode)) ? 'd' : '-';
    permissions[1] = (mode & S_IRUSR) ? 'r' : '-'; //user permissions
    permissions[2] = (mode & S_IWUSR) ? 'w' : '-'; 
    permissions[3] = (mode & S_IXUSR) ? 'x' : '-';
    permissions[4] = (mode & S_IRGRP) ? 'r' : '-'; //group permissions
    permissions[5] = (mode & S_IWGRP) ? 'w' : '-';
    permissions[6] = (mode & S_IXGRP) ? 'x' : '-';
    permissions[7] = (mode & S_IROTH) ? 'r' : '-'; //others permissions
    permissions[8] = (mode & S_IWOTH) ? 'w' : '-';
    permissions[9] = (mode & S_IXOTH) ? 'x' : '-';
    permissions[10] = '\0';
    return permissions;
}

void printFileInfo(const char *filename) { //information about file, like ls -l 
    struct stat file; 
    if (stat(filename, &file) == -1) { //gets information about file 
        perror("Error getting file info"); 
        return;
    }
    struct passwd *user = getpwuid(file.st_uid); //gets information about user, below about group 
    struct group *group = getgrgid(file.st_gid);
    char date[20];
    setlocale(LC_TIME, "pl_PL.UTF-8"); 
    strftime(date, sizeof(date), "%d %b %H:%M", localtime(&file.st_mtime)); //gets date of last modification of file, date format (day month hour:minute)
    char *permissions = getPermissions(file.st_mode); 
    const char *fileName = strrchr(filename, '/'); //gets name of file by searching for last occurence of '/' in path
    if (fileName == NULL) { //avoids printing '/' in case of file in current directory
        fileName = filename;
    } else {
        fileName++; 
    }
    printf("%s  %5hu %-10s %-8s %8lld %s %s\n", permissions, (unsigned short)file.st_nlink, user->pw_name, group->gr_name, (long long)file.st_size, date, fileName); //prints information about file in format like ls -l
    free(permissions); //
}

void listDirectory(const char *path) { //information about files in directory 
    DIR *dir = opendir(path); 
    if (dir == NULL) { 
        perror("Error opening directory");
        return;
    }
    struct dirent *entry;
    struct stat file;
    int total = 0; //total size of files in directory
    while ((entry = readdir(dir)) != NULL) { //reads directory, if entry is NULL, end of directory
        if (entry->d_name[0] == '.') {
            continue;
        }
        char filePath[PATH_MAX];
        snprintf(filePath, sizeof(filePath), "%s/%s", path, entry->d_name); //creates path to file and saves it in filePath
        if (stat(filePath, &file) == -1) {
            perror("Error getting file info");
            continue;
        }
        total += file.st_blocks; //adds size of file to total
        printFileInfo(filePath);
    }
    closedir(dir);
    printf("Total %d\n", total); //prints total size of files in directory
}

void recDirectory(char *path, int flag) { //recursive function for printing files in directory and subdirectories
    DIR *directory = opendir(path);
    if (!directory) {
        perror(path);
        return;
    }
    struct dirent *entry;
    char newdir[512]; //path to subdirectory
    printf("\n%s:\n", path); //prints path to directory
    while ((entry = readdir(directory))) { //prints files in directory
        if (strncmp(entry->d_name, ".", 1)) { //avoids printing files starting with '.'
             printf("   %s\n", entry->d_name);
        }
    }
    closedir(directory);
    directory = opendir(path);
    while ((entry = readdir(directory))) { //prints subdirectories
        if (strncmp(entry->d_name, ".", 1)) { 
            if (flag && entry->d_type == 4) { 
                sprintf(newdir, "%s/%s", path, entry->d_name); //creates path to subdirectory
                recDirectory(newdir, 1); 
            }
        }
    }
    closedir(directory);
}

void printDirectorySize(const char *path) { //prints size of directory
    DIR *directory = opendir(path);
    if (directory == NULL) {
        perror("Error opening directory");
        return;
    }
    struct dirent *entry;
    struct stat file;
    int total = 0; //total size of files in directory
    int fileCount = 0; //number of files in line
    while ((entry = readdir(directory)) != NULL) {
        if (entry->d_name[0] == '.')
            continue;
        char filePath[PATH_MAX];
        snprintf(filePath, sizeof(filePath), "%s/%s", path, entry->d_name); //creates path to file and saves it in filePath
        if (stat(filePath, &file) == -1) { 
            perror("Error");
            continue;
        }
        total += file.st_blocks;
        const char *fileName = strrchr(filePath, '/'); //gets name of file by searching for last occurence of '/' in path
        if (fileName == NULL) { //avoids printing '/' in case of file in current directory
            fileName = filePath;
        } else {
            fileName++;
        }
        printf("%4lld %-35.35s ", (long long)(file.st_blocks), fileName); //prints size of file and name of file
        fileCount++;
        if (fileCount % 3 == 0) { //prints 3 files in every line
            printf("\n");
        }
    }
    closedir(directory);
    printf("\nTotal %d\n", total); //prints total size of files in directory
}

void listDirectoryAll(const char *path) { //information about files in directory, including hidden files
    DIR *directory = opendir(path);
    if (directory == NULL) {
        perror("Error opening directory");
        return;
    }
    struct dirent *entry;
    struct stat file;
    int count = 0;
    while ((entry = readdir(directory)) != NULL) { //reads directory, if entry is NULL, end of directory
        char filePath[PATH_MAX];
        snprintf(filePath, sizeof(filePath), "%s/%s", path, entry->d_name); //creates path to file and saves it in filePath
        if (stat(filePath, &file) == -1) {
            perror("stat");
            continue;
        }
        if (count % 3 == 0 && count != 0) { //prints 3 files in every line
            printf("\n");
        }
        printf("%-25.25s ", entry->d_name); //prints name of file
        count++;
    }
    closedir(directory);
    printf("\n");
}

void addSlash(const char *path) { //adds '/' to directories
    DIR *directory = opendir(path);
    if (directory == NULL) {
        perror("Error opening directory");
        return;
    }
    struct dirent *entry;
    struct stat file;
    while ((entry = readdir(directory)) != NULL) { //reads directory, if entry is NULL, end of directory
        if (entry->d_name[0] != '.') { //avoids printing files starting with '.'
            char dir[1024];
            snprintf(dir, sizeof(dir), "%s/%s", path, entry->d_name); //creates path to file and saves it in dir
            if (stat(dir, &file) == 0) {
                if (S_ISDIR(file.st_mode)) { //checks if file is directory
                    printf("%s/\n", entry->d_name); //prints name of directory with '/'
                } else {
                    printf("%s\n", entry->d_name); //prints name of file
                }
            }
        }
    }
    closedir(directory);
}

int main(int argc, char *argv[]) {
    if (argc != 3) { //checks if number of arguments is correct
        printf("Usage: ./ls [option] [directory]\n");
        return 0;
    }
    char *option = argv[1];
    char *directory = argv[2];
    if (strcmp(option, "-l") == 0) { //checks which option was chosen, if none, prints error, 1. ls -l
        listDirectory(directory);
    } else if (strcmp(option, "-R") == 0) { // 2. ls -R
        recDirectory(directory, 1);
    } else if (strcmp(option, "-s") == 0) { // 3. ls -s
        printDirectorySize(directory);
    } else if (strcmp(option, "-a") == 0) { // 4. ls -a
        listDirectoryAll(directory);
    } else if (strcmp(option, "-p") == 0) { // 5. ls -p
        addSlash(directory);
    } else {
        printf("Invalid option: %s\n", option);
        return 0;
    }
    return 0;
}