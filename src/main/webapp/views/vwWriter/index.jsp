<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="t" tagdir="/WEB-INF/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<jsp:useBean
        id="articles"
        scope="request"
        type="java.util.List<com.example.googlenewsclone.beans.Article>"
/>

<t:writer>
    <jsp:body>
        <div class="mt-10">
            <h1 class="text-gray-600 text-3xl font-bold mx-4">
                Quản lý bài viết của bạn
            </h1>
            <div
                    class="overflow-x-auto relative shadow-md sm:rounded-lg mx-4 my-8 border border-gray-200"
            >
                <table
                        class="w-full text-sm text-left text-gray-500 dark:text-gray-400"
                >
                    <thead
                            class="text-xs text-gray-700 uppercase bg-gray-50 dark:bg-gray-700 dark:text-gray-400"
                    >
                    <tr>
                        <th scope="col" class="py-3 px-6">ID</th>
                        <th scope="col" class="py-3 px-6">Tiêu đề</th>
                        <th scope="col" class="py-3 px-6">Trạng thái</th>
                        <th scope="col" class="py-3 px-6">Hành động</th>
                        <th scope="col" class="py-3 px-6">Chỉnh sửa</th>
                    </tr>
                    </thead>
                    <tbody>

                    <c:forEach items="${articles}" var="a">
                        <c:choose>
                            <c:when test="${a.statusID == 1}">
                                <tr
                                        class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                                >
                                    <th
                                            scope="row"
                                            class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                    >
                                            ${a.articleID}
                                    </th>
                                    <td class="py-4 px-6">
                                        <p class="text-gray-500 text-sm w-[400px] truncate">
                                                ${a.title}
                                        </p>
                                    </td>


                                    <td class="py-4 px-6">
                                        <p
                                                class="text-yellow-800 font-bold bg-yellow-50 rounded-full px-2 py-1 text-center"
                                        >
                                            Đang chờ
                                        </p>
                                    </td>
                                    <td class="py-4 px-6">

                                        <div class="flex gap-x-1 w-fit items-center">
                                            <form method="post" action="${pageContext.request.contextPath}/Staff/Editor/UpdateStatus">
                                                <input name="articleid" type="hidden" value=${a.articleID} />
                                                <input name="statusid" type="hidden" value="3" />

                                                <button
                                                        type="submit"
                                                        class="rounded-full p-2 hover:bg-gray-200"
                                                >
                                                    <svg
                                                            xmlns="http://www.w3.org/2000/svg"
                                                            fill="none"
                                                            viewBox="0 0 24 24"
                                                            stroke-width="1.5"
                                                            stroke="gray"
                                                            class="w-6 h-6"
                                                    >
                                                        <path
                                                                stroke-linecap="round"
                                                                stroke-linejoin="round"
                                                                d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5m6 4.125l2.25 2.25m0 0l2.25 2.25M12 13.875l2.25-2.25M12 13.875l-2.25 2.25M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"
                                                        />
                                                    </svg>
                                                </button>
                                            </form>

                                            <form method="post" action="${pageContext.request.contextPath}/Staff/Editor/UpdateStatus">
                                                <input name="articleid" type="hidden" value=${a.articleID} />
                                                <input name="statusid" type="hidden" value="2" />

                                                <button
                                                        type="submit"
                                                        class="rounded-full p-2 hover:bg-gray-200"
                                                >
                                                    <svg
                                                            xmlns="http://www.w3.org/2000/svg"
                                                            fill="none"
                                                            viewBox="0 0 24 24"
                                                            stroke-width="1.5"
                                                            stroke="gray"
                                                            class="w-6 h-6"
                                                    >
                                                        <path
                                                                stroke-linecap="round"
                                                                stroke-linejoin="round"
                                                                d="M10.125 2.25h-4.5c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125v-9M10.125 2.25h.375a9 9 0 019 9v.375M10.125 2.25A3.375 3.375 0 0113.5 5.625v1.5c0 .621.504 1.125 1.125 1.125h1.5a3.375 3.375 0 013.375 3.375M9 15l2.25 2.25L15 12"
                                                        />
                                                    </svg>
                                                </button>
                                            </form>

                                        </div>
                                    </td>
                                    <td class="py-4 px-6">
                                        <a href="${pageContext.request.contextPath}/Staff/Writer/Edit?id=${a.articleID}" class="rounded-full p-2 hover:bg-gray-200">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="gray" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
                                            </svg>
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:when test="${a.statusID == 3}">
                                <tr
                                        class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                                >
                                    <th
                                            scope="row"
                                            class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                    >
                                            ${a.articleID}
                                    </th>
                                    <td class="py-4 px-6">
                                        <p class="text-gray-500 text-sm w-[400px] truncate">
                                                ${a.title}
                                        </p>
                                    </td>


                                    <td class="py-4 px-6">
                                        <p
                                                class="text-red-800 font-bold bg-red-50 rounded-full px-2 py-1 text-center"
                                        >
                                            Bị từ chối
                                        </p>
                                    </td>
                                    <td class="py-4 px-6">
                                        <div class="flex gap-x-1 w-fit items-center opacity-50">
                                            <button type="submit" class="rounded-full p-2">
                                                <svg
                                                        xmlns="http://www.w3.org/2000/svg"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke-width="1.5"
                                                        stroke="gray"
                                                        class="w-6 h-6"
                                                >
                                                    <path
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round"
                                                            d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5m6 4.125l2.25 2.25m0 0l2.25 2.25M12 13.875l2.25-2.25M12 13.875l-2.25 2.25M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"
                                                    />
                                                </svg>
                                            </button>
                                            <button type="submit" class="rounded-full p-2">
                                                <svg
                                                        xmlns="http://www.w3.org/2000/svg"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke-width="1.5"
                                                        stroke="gray"
                                                        class="w-6 h-6"
                                                >
                                                    <path
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round"
                                                            d="M10.125 2.25h-4.5c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125v-9M10.125 2.25h.375a9 9 0 019 9v.375M10.125 2.25A3.375 3.375 0 0113.5 5.625v1.5c0 .621.504 1.125 1.125 1.125h1.5a3.375 3.375 0 013.375 3.375M9 15l2.25 2.25L15 12"
                                                    />
                                                </svg>
                                            </button>
                                        </div>
                                    </td>
                                    <td class="py-4 px-6">
                                        <a href="${pageContext.request.contextPath}/Staff/Writer/Edit?id=${a.articleID}" class="rounded-full p-2 hover:bg-gray-200">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="gray" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
                                            </svg>
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:when test="${a.statusID == 2}">
                                <tr
                                        class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                                >
                                    <th
                                            scope="row"
                                            class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                    >
                                            ${a.articleID}
                                    </th>
                                    <td class="py-4 px-6">
                                        <p class="text-gray-500 text-sm w-[400px] truncate">
                                                ${a.title}
                                        </p>
                                    </td>

                                    <td class="py-4 px-6">
                                        <p
                                                class="text-blue-800 font-bold bg-blue-50 rounded-full px-2 py-1 text-center"
                                        >
                                            Đã duyệt
                                        </p>
                                    </td>
                                    <td class="py-4 px-6">
                                        <form method="post" action="${pageContext.request.contextPath}/Staff/Editor/UpdateStatus">
                                            <input type="hidden" name="articleid" value=${a.articleID}>
                                            <input type="hidden" name="statusid" value="4">
                                            <button
                                                    type="submit"
                                                    class="rounded-lg px-4 py-2 w-fit flex gap-x-2 text-sm bg-blue-500 text-white items-center font-bold hover:opacity-50"
                                            >

                                                Xuất bản
                                                <svg
                                                        xmlns="http://www.w3.org/2000/svg"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke-width="1.5"
                                                        stroke="white"
                                                        class="w-6 h-6"
                                                >
                                                    <path
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round"
                                                            d="M3 16.5v2.25A2.25 2.25 0 005.25 21h13.5A2.25 2.25 0 0021 18.75V16.5m-13.5-9L12 3m0 0l4.5 4.5M12 3v13.5"
                                                    />
                                                </svg>
                                            </button>
                                        </form>
                                    </td>
                                    <td class="py-4 px-6">
                                        <a href="${pageContext.request.contextPath}/Staff/Writer/Edit?id=${a.articleID}" class="rounded-full p-2 hover:bg-gray-200">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="gray" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
                                            </svg>
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                            <c:when test="${a.statusID == 4}">
                                <tr
                                        class="bg-white border-b dark:bg-gray-800 dark:border-gray-700"
                                >
                                    <th
                                            scope="row"
                                            class="py-4 px-6 font-medium text-gray-900 whitespace-nowrap dark:text-white"
                                    >
                                            ${a.articleID}
                                    </th>
                                    <td class="py-4 px-6">
                                        <p class="text-gray-500 text-sm w-[400px] truncate">
                                                ${a.title}
                                        </p>
                                    </td>

                                    <td class="py-4 px-6">
                                        <p
                                                class="text-green-800 font-bold bg-green-50 rounded-full px-2 py-1 text-center"
                                        >
                                            Đã xuất bản
                                        </p>
                                    </td>
                                    <td class="py-4 px-6">
                                        <div class="flex gap-x-1 w-fit items-center opacity-50">
                                            <button type="submit" class="rounded-full p-2">
                                                <svg
                                                        xmlns="http://www.w3.org/2000/svg"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke-width="1.5"
                                                        stroke="gray"
                                                        class="w-6 h-6"
                                                >
                                                    <path
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round"
                                                            d="M20.25 7.5l-.625 10.632a2.25 2.25 0 01-2.247 2.118H6.622a2.25 2.25 0 01-2.247-2.118L3.75 7.5m6 4.125l2.25 2.25m0 0l2.25 2.25M12 13.875l2.25-2.25M12 13.875l-2.25 2.25M3.375 7.5h17.25c.621 0 1.125-.504 1.125-1.125v-1.5c0-.621-.504-1.125-1.125-1.125H3.375c-.621 0-1.125.504-1.125 1.125v1.5c0 .621.504 1.125 1.125 1.125z"
                                                    />
                                                </svg>
                                            </button>
                                            <button type="submit" class="rounded-full p-2">
                                                <svg
                                                        xmlns="http://www.w3.org/2000/svg"
                                                        fill="none"
                                                        viewBox="0 0 24 24"
                                                        stroke-width="1.5"
                                                        stroke="gray"
                                                        class="w-6 h-6"
                                                >
                                                    <path
                                                            stroke-linecap="round"
                                                            stroke-linejoin="round"
                                                            d="M10.125 2.25h-4.5c-.621 0-1.125.504-1.125 1.125v17.25c0 .621.504 1.125 1.125 1.125h12.75c.621 0 1.125-.504 1.125-1.125v-9M10.125 2.25h.375a9 9 0 019 9v.375M10.125 2.25A3.375 3.375 0 0113.5 5.625v1.5c0 .621.504 1.125 1.125 1.125h1.5a3.375 3.375 0 013.375 3.375M9 15l2.25 2.25L15 12"
                                                    />
                                                </svg>
                                            </button>
                                        </div>
                                    </td>
                                    <td class="py-4 px-6">
                                        <a href="${pageContext.request.contextPath}/Staff/Writer/Edit?id=${a.articleID}" class="rounded-full p-2 hover:bg-gray-200">
                                            <svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" stroke-width="2" stroke="gray" class="w-6 h-6">
                                                <path stroke-linecap="round" stroke-linejoin="round" d="M16.862 4.487l1.687-1.688a1.875 1.875 0 112.652 2.652L6.832 19.82a4.5 4.5 0 01-1.897 1.13l-2.685.8.8-2.685a4.5 4.5 0 011.13-1.897L16.863 4.487zm0 0L19.5 7.125" />
                                            </svg>
                                        </a>
                                    </td>
                                </tr>
                            </c:when>
                        </c:choose>
                    </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </jsp:body>
</t:writer>